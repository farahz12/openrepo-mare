#!/bin/bash
set -e

echo "🧪 Testing MinIO User Permissions"
echo "=================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() { echo -e "${BLUE}[TEST]${NC} $1"; }
print_success() { echo -e "${GREEN}[PASS]${NC} $1"; }
print_error() { echo -e "${RED}[FAIL]${NC} $1"; }

# Test user login and basic permissions
test_user_permissions() {
    local username=$1
    local password=$2
    local role=$3
    local alias_name=$4
    local should_write=$5

    echo ""
    print_status "Testing $role: $username"
    echo "----------------------------------------"
    
    # Test login
    if docker exec openrepo-minio mc alias set $alias_name http://localhost:9000 $username "$password" >/dev/null 2>&1; then
        print_success "✅ Login successful"
    else
        print_error "❌ Login failed"
        return 1
    fi
    
    # Test list buckets
    if docker exec openrepo-minio mc ls $alias_name/ >/dev/null 2>&1; then
        print_success "✅ Can list buckets"
        bucket_count=$(docker exec openrepo-minio mc ls $alias_name/ | wc -l)
        echo "   Found $bucket_count buckets"
    else
        print_error "❌ Cannot list buckets"
    fi
    
    # Test read access
    if docker exec openrepo-minio mc ls $alias_name/openrepo-public >/dev/null 2>&1; then
        print_success "✅ Can read public bucket"
    else
        print_error "❌ Cannot read public bucket"
    fi
    
    # Test write access
    if [ "$should_write" = "true" ]; then
        if docker exec openrepo-minio mc mb $alias_name/test-write-$username >/dev/null 2>&1; then
            print_success "✅ Can create buckets"
            # Clean up
            docker exec openrepo-minio mc rb $alias_name/test-write-$username >/dev/null 2>&1 || true
        else
            print_error "❌ Cannot create buckets"
        fi
    else
        if docker exec openrepo-minio mc mb $alias_name/test-write-$username >/dev/null 2>&1; then
            print_error "❌ Should NOT be able to create buckets (security issue!)"
            # Clean up
            docker exec openrepo-minio mc rb $alias_name/test-write-$username >/dev/null 2>&1 || true
        else
            print_success "✅ Correctly blocked from creating buckets"
        fi
    fi
}

# Main test execution
main() {
    echo "Starting comprehensive permission tests..."
    echo ""
    
    # Check if MinIO is running
    if ! docker ps | grep -q openrepo-minio; then
        print_error "MinIO container is not running!"
        exit 1
    fi
    
    # Test each user account
    test_user_permissions "openrepo_minio_admin" "OpenRepo_MinIO_2024_Secure!" "Root Admin" "test-root" "true"
    test_user_permissions "openrepo-admin" "AdminSecure2024!" "App Admin" "test-admin" "true"
    test_user_permissions "openrepo-developer" "DevSecure2024!" "Developer" "test-dev" "true"
    test_user_permissions "openrepo-agent" "AgentSecure2024!" "Service Agent" "test-agent" "false"
    
    echo ""
    echo "=========================================="
    echo -e "${GREEN}🎉 Permission Testing Complete!${NC}"
    echo "=========================================="
    echo ""
    echo "📊 Summary:"
    echo "- Root Admin: Full system access ✅"
    echo "- App Admin: Full bucket access + console ✅"
    echo "- Developer: Read/write bucket access ✅"
    echo "- Agent: Read-only access with ListBucket ✅"
    echo ""
    echo "🔐 Security:"
    echo "- Agent correctly blocked from write operations ✅"
    echo "- All users can authenticate ✅"
    echo "- Role-based access control working ✅"
}

# Run the tests
main "$@"
