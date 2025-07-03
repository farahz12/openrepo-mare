#!/bin/bash
set -e

echo "🧪 Testing MinIO Setup"
echo "====================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

test_user() {
    local username=$1
    local password=$2
    local role=$3
    local icon=$4
    
    echo ""
    echo -e "${YELLOW}$icon Testing $role ($username)${NC}"
    echo "================================"
    
    # Test connection
    if docker exec openrepo-minio mc alias set test-$username http://localhost:9000 $username $password 2>/dev/null; then
        echo -e "${GREEN}✅ Connection successful${NC}"
        
        # Test bucket access
        local bucket_count=$(docker exec openrepo-minio mc ls test-$username 2>/dev/null | wc -l)
        echo -e "${GREEN}✅ Can see $bucket_count buckets${NC}"
        
        # Test file operations based on role
        if [[ "$role" == "ADMIN" ]] || [[ "$role" == "DEVELOPER" ]]; then
            # Test upload for admin and developer
            if echo "Test file by $username" | docker exec -i openrepo-minio mc pipe test-$username/openrepo-artifacts/test-$username.txt 2>/dev/null; then
                echo -e "${GREEN}✅ Can upload files${NC}"
                
                # Test download
                if docker exec openrepo-minio mc cat test-$username/openrepo-artifacts/test-$username.txt >/dev/null 2>&1; then
                    echo -e "${GREEN}✅ Can download files${NC}"
                else
                    echo -e "${RED}❌ Cannot download files${NC}"
                fi
                
                # Clean up test file
                docker exec openrepo-minio mc rm test-$username/openrepo-artifacts/test-$username.txt 2>/dev/null || true
            else
                echo -e "${RED}❌ Cannot upload files${NC}"
            fi
        else
            # For AGENT (readonly), test that upload fails
            if echo "Test file by $username" | docker exec -i openrepo-minio mc pipe test-$username/openrepo-artifacts/test-$username.txt 2>/dev/null; then
                echo -e "${RED}❌ SECURITY ISSUE: Agent can upload (should be readonly!)${NC}"
                docker exec openrepo-minio mc rm test-$username/openrepo-artifacts/test-$username.txt 2>/dev/null || true
            else
                echo -e "${GREEN}✅ Cannot upload files (correct for readonly)${NC}"
            fi
        fi
        
        # Clean up alias
        docker exec openrepo-minio mc alias remove test-$username 2>/dev/null || true
    else
        echo -e "${RED}❌ Connection failed${NC}"
    fi
}

# Check if MinIO is running
if ! docker ps | grep -q openrepo-minio; then
    echo -e "${RED}❌ MinIO container not running${NC}"
    exit 1
fi

echo -e "${BLUE}🔍 Basic connectivity test...${NC}"
if docker exec openrepo-minio mc alias set test-basic http://localhost:9000 openrepo_minio_admin 'OpenRepo_MinIO_2024_Secure!' 2>/dev/null; then
    echo -e "${GREEN}✅ MinIO server is accessible${NC}"
    docker exec openrepo-minio mc alias remove test-basic 2>/dev/null || true
else
    echo -e "${RED}❌ Cannot connect to MinIO server${NC}"
    exit 1
fi

# Test all users
test_user "openrepo-admin" "AdminSecure2024!" "ADMIN" "👑"
test_user "openrepo-developer" "DevSecure2024!" "DEVELOPER" "🛠️"
test_user "openrepo-agent" "AgentSecure2024!" "AGENT" "👀"

echo ""
echo -e "${BLUE}📦 Bucket accessibility test...${NC}"
docker exec openrepo-minio mc alias set test-admin-final http://localhost:9000 openrepo-admin AdminSecure2024! 2>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}🗂️  Available buckets:${NC}"
    docker exec openrepo-minio mc ls test-admin-final 2>/dev/null | while read line; do
        echo "   📁 $line"
    done
    docker exec openrepo-minio mc alias remove test-admin-final 2>/dev/null || true
fi

echo ""
echo -e "${GREEN}✅ Testing completed!${NC}"
echo ""
echo -e "${BLUE}📋 Summary:${NC}"
echo "  👑 Admin: Full access (read/write/delete)"
echo "  🛠️  Developer: Read/write access to work buckets"
echo "  👀 Agent: Read-only access"
echo ""
echo -e "${YELLOW}🌐 Access MinIO Console: http://localhost:9001${NC}"
