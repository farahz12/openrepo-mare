#!/bin/bash

echo "📊 MinIO Status Monitor"
echo "======================"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check container status
echo -e "${BLUE}🐳 Container Status:${NC}"
if docker ps | grep -q openrepo-minio; then
    echo -e "${GREEN}✅ MinIO container is running${NC}"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep minio
else
    echo -e "${RED}❌ MinIO container not running${NC}"
    exit 1
fi

# Configure alias if needed
docker exec openrepo-minio mc alias set minio-admin http://localhost:9000 openrepo_minio_admin 'OpenRepo_MinIO_2024_Secure!' 2>/dev/null || {
    echo -e "${RED}❌ Cannot connect to MinIO${NC}"
    exit 1
}

echo ""
echo -e "${BLUE}📦 Buckets:${NC}"
docker exec openrepo-minio mc ls minio-admin 2>/dev/null || echo -e "${RED}Cannot list buckets${NC}"

echo ""
echo -e "${BLUE}👥 Users:${NC}"
docker exec openrepo-minio mc admin user list minio-admin 2>/dev/null || echo -e "${RED}Cannot list users${NC}"

echo ""
echo -e "${BLUE}💾 Storage Usage:${NC}"
for bucket in openrepo-artifacts openrepo-repos openrepo-logs openrepo-uploads openrepo-releases openrepo-backups; do
    if docker exec openrepo-minio mc ls minio-admin/$bucket >/dev/null 2>&1; then
        size=$(docker exec openrepo-minio mc du minio-admin/$bucket 2>/dev/null | awk '{print $1}' || echo "0")
        echo -e "   📦 $bucket: ${GREEN}$size${NC}"
    else
        echo -e "   📦 $bucket: ${YELLOW}Not found${NC}"
    fi
done

echo ""
echo -e "${BLUE}🔐 Bucket Policies:${NC}"
for bucket in openrepo-artifacts openrepo-repos openrepo-logs openrepo-uploads openrepo-releases openrepo-backups; do
    if docker exec openrepo-minio mc ls minio-admin/$bucket >/dev/null 2>&1; then
        policy=$(docker exec openrepo-minio mc anonymous get minio-admin/$bucket 2>/dev/null || echo "none")
        echo -e "   📦 $bucket: ${GREEN}$policy${NC}"
    fi
done

echo ""
echo -e "${BLUE}📈 Server Info:${NC}"
docker exec openrepo-minio mc admin info minio-admin 2>/dev/null || echo -e "${RED}Cannot get server info${NC}"

echo ""
echo -e "${BLUE}🌐 Access URLs:${NC}"
echo -e "   Console: ${GREEN}http://localhost:9001${NC}"
echo -e "   API: ${GREEN}http://localhost:9000${NC}"

echo ""
echo -e "${BLUE}🔑 Test Connections:${NC}"
# Quick connectivity test
if docker exec openrepo-minio mc alias set test-conn http://localhost:9000 openrepo-admin AdminSecure2024! 2>/dev/null; then
    echo -e "   👑 Admin: ${GREEN}✅ Connected${NC}"
    docker exec openrepo-minio mc alias remove test-conn 2>/dev/null
else
    echo -e "   👑 Admin: ${RED}❌ Connection failed${NC}"
fi

if docker exec openrepo-minio mc alias set test-conn http://localhost:9000 openrepo-developer DevSecure2024! 2>/dev/null; then
    echo -e "   🛠️  Developer: ${GREEN}✅ Connected${NC}"
    docker exec openrepo-minio mc alias remove test-conn 2>/dev/null
else
    echo -e "   🛠️  Developer: ${RED}❌ Connection failed${NC}"
fi

if docker exec openrepo-minio mc alias set test-conn http://localhost:9000 openrepo-agent AgentSecure2024! 2>/dev/null; then
    echo -e "   👀 Agent: ${GREEN}✅ Connected${NC}"
    docker exec openrepo-minio mc alias remove test-conn 2>/dev/null
else
    echo -e "   👀 Agent: ${RED}❌ Connection failed${NC}"
fi
