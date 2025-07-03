#!/bin/bash
set -e

echo "🚀 OpenRepo MinIO Complete Setup"
echo "==============================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if MinIO is running
if ! docker ps | grep -q openrepo-minio; then
    print_error "MinIO container not running. Please start it first with:"
    echo "docker-compose -f docker-compose.prod.yml up -d minio"
    exit 1
fi

# Wait for MinIO to be ready
print_status "Waiting for MinIO to be ready..."
sleep 10

# Configure admin alias
print_status "Configuring MinIO admin access..."
docker exec openrepo-minio mc alias set minio-admin http://localhost:9000 openrepo_minio_admin 'OpenRepo_MinIO_2024_Secure!'

if [ $? -ne 0 ]; then
    print_error "Failed to configure admin access. Check MinIO credentials."
    exit 1
fi

# Create buckets
print_status "Creating buckets..."
buckets=(
    "openrepo-artifacts:Build artifacts and files"
    "openrepo-uploads:Temporary uploads" 
    "openrepo-releases:Release versions"
    "openrepo-repos:Git repositories"
    "openrepo-logs:System logs"
    "openrepo-backups:System backups"
)

for bucket_info in "${buckets[@]}"; do
    bucket_name=$(echo $bucket_info | cut -d: -f1)
    bucket_desc=$(echo $bucket_info | cut -d: -f2)
    
    docker exec openrepo-minio mc mb minio-admin/$bucket_name --ignore-existing
    if [ $? -eq 0 ]; then
        print_success "Created $bucket_name - $bucket_desc"
    else
        print_error "Failed to create $bucket_name"
    fi
done

# Create users
print_status "Creating users..."
users=(
    "openrepo-admin:AdminSecure2024!:Admin user"
    "openrepo-developer:DevSecure2024!:Developer user"
    "openrepo-agent:AgentSecure2024!:Read-only agent"
)

for user_info in "${users[@]}"; do
    username=$(echo $user_info | cut -d: -f1)
    password=$(echo $user_info | cut -d: -f2)
    description=$(echo $user_info | cut -d: -f3)
    
    docker exec openrepo-minio mc admin user add minio-admin "$username" "$password" 2>/dev/null || true
    print_success "Created $username - $description"
done

# Apply policies
print_status "Applying user policies..."
docker exec openrepo-minio mc admin policy attach minio-admin readwrite --user openrepo-admin
docker exec openrepo-minio mc admin policy attach minio-admin readwrite --user openrepo-developer  
docker exec openrepo-minio mc admin policy attach minio-admin readonly --user openrepo-agent

# Configure bucket policies
print_status "Setting bucket permissions..."
docker exec openrepo-minio mc anonymous set public minio-admin/openrepo-artifacts
docker exec openrepo-minio mc anonymous set public minio-admin/openrepo-releases
docker exec openrepo-minio mc anonymous set private minio-admin/openrepo-logs
docker exec openrepo-minio mc anonymous set private minio-admin/openrepo-backups
docker exec openrepo-minio mc anonymous set private minio-admin/openrepo-repos
docker exec openrepo-minio mc anonymous set public minio-admin/openrepo-uploads

print_success "MinIO setup completed successfully!"

echo ""
echo -e "${BLUE}📝 SUMMARY:${NC}"
echo "==========="
echo -e "${GREEN}🌐 MinIO Console:${NC} http://localhost:9001"
echo -e "${GREEN}🔑 Admin:${NC} openrepo_minio_admin / OpenRepo_MinIO_2024_Secure!"
echo ""
echo -e "${GREEN}👥 OpenRepo Users:${NC}"
echo "  👑 Admin: openrepo-admin / AdminSecure2024!"
echo "  🛠️  Developer: openrepo-developer / DevSecure2024!"
echo "  👀 Agent: openrepo-agent / AgentSecure2024!"
echo ""
echo -e "${GREEN}📦 Buckets Created:${NC}"
for bucket_info in "${buckets[@]}"; do
    bucket_name=$(echo $bucket_info | cut -d: -f1)
    bucket_desc=$(echo $bucket_info | cut -d: -f2)
    echo "  📁 $bucket_name - $bucket_desc"
done
echo ""
echo -e "${YELLOW}💡 Next steps:${NC}"
echo "  1. Test the setup: ./test-minio.sh"
echo "  2. Monitor status: ./monitor-buckets.sh"
echo "  3. Access console: http://localhost:9001"
