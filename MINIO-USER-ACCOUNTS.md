# MinIO User Accounts and Permissions Summary

## 👥 User Accounts Overview

The OpenRepo MinIO setup now includes **4 user accounts** with distinct roles and permissions:

### 🔐 Root Administrator
- **Username**: `openrepo_minio_admin`
- **Password**: `OpenRepo_MinIO_2024_Secure!`
- **Role**: Super Admin
- **Permissions**: Full system administration
- **Console Access**: Full administrative console access

### 🛠️ Application Administrator
- **Username**: `openrepo-admin`
- **Password**: `AdminSecure2024!`
- **Role**: Application Admin
- **Permissions**: 
  - Full read/write access to all buckets
  - Console administration capabilities
  - User management permissions
- **Policies**: `readwrite` + `consoleAdmin`

### 👨‍💻 Developer
- **Username**: `openrepo-developer`
- **Password**: `DevSecure2024!`
- **Role**: Developer
- **Permissions**:
  - Full read/write access to all buckets
  - Can upload, download, and manage objects
  - Can create and delete buckets
- **Policies**: `readwrite`

### 👀 Service Agent
- **Username**: `openrepo-agent`
- **Password**: `AgentSecure2024!`
- **Role**: Read-Only Service Account
- **Permissions**:
  - Read-only access to all buckets
  - Can list buckets and objects
  - Cannot create, modify, or delete anything
- **Policies**: `agent-readonly` (custom policy)

## 🎯 Permission Matrix

| Action | Root Admin | App Admin | Developer | Agent |
|--------|:----------:|:---------:|:---------:|:-----:|
| List Buckets | ✅ | ✅ | ✅ | ✅ |
| Create Buckets | ✅ | ✅ | ✅ | ❌ |
| Delete Buckets | ✅ | ✅ | ✅ | ❌ |
| Upload Objects | ✅ | ✅ | ✅ | ❌ |
| Download Objects | ✅ | ✅ | ✅ | ✅ |
| Delete Objects | ✅ | ✅ | ✅ | ❌ |
| Manage Users | ✅ | ✅ | ❌ | ❌ |
| Console Access | ✅ | ✅ | ❌ | ❌ |
| Set Policies | ✅ | ✅ | ❌ | ❌ |

## 🪣 Current Buckets

| Bucket Name | Purpose | Access Policy |
|-------------|---------|---------------|
| `openrepo-packages` | Production packages | Private |
| `openrepo-uploads` | Temporary uploads | Private |
| `openrepo-public` | Public downloads | Public (anonymous read) |
| `test` | Testing bucket | Private |
| `test-public-bucket` | Public test bucket | Public (anonymous read) |

## 🚀 Quick Login Guide

### Console Access (http://localhost:9001)

**For Administrative Tasks:**
```
Username: openrepo_minio_admin
Password: OpenRepo_MinIO_2024_Secure!
```

**For Application Management:**
```
Username: openrepo-admin
Password: AdminSecure2024!
```

### Command Line Access

**Root Admin:**
```bash
mc alias set root-admin http://localhost:9000 openrepo_minio_admin 'OpenRepo_MinIO_2024_Secure!'
```

**App Admin:**
```bash
mc alias set app-admin http://localhost:9000 openrepo-admin 'AdminSecure2024!'
```

**Developer:**
```bash
mc alias set developer http://localhost:9000 openrepo-developer 'DevSecure2024!'
```

**Agent (Read-only):**
```bash
mc alias set agent http://localhost:9000 openrepo-agent 'AgentSecure2024!'
```

## 🔧 Testing Commands

### Test All User Permissions:
```bash
# Test admin access
docker exec openrepo-minio mc ls admin-test/

# Test developer access  
docker exec openrepo-minio mc ls dev-test/

# Test agent access (read-only)
docker exec openrepo-minio mc ls agent-test/

# Test agent cannot write (should fail)
docker exec openrepo-minio mc mb agent-test/should-fail
```

### Current Status:
```bash
# List all users
docker exec openrepo-minio mc admin user list admin-conn

# List all policies
docker exec openrepo-minio mc admin policy list admin-conn

# List all buckets
docker exec openrepo-minio mc ls admin-conn/
```

## 📋 Management Scripts

The following scripts are available for managing the setup:

- `./start-openrepo-production.sh` - Start all services
- `./setup-minio.sh` - Initialize MinIO configuration
- `./test-minio.sh` - Test all user permissions
- `./health-check.sh` - Verify system health
- `./monitor-buckets.sh` - Monitor bucket usage

## 🔒 Security Notes

1. **Password Security**: All passwords use secure, unique values
2. **Principle of Least Privilege**: Each user has only necessary permissions
3. **Role Separation**: Clear distinction between admin, developer, and service roles
4. **Custom Policies**: Agent uses custom read-only policy with ListBucket capability
5. **Console Access**: Limited to admin users only

## ✅ Verification Status

- ✅ All 4 users created successfully
- ✅ Permissions properly assigned and tested
- ✅ Agent read-only access working with custom policy
- ✅ Admin and developer full access confirmed
- ✅ Console access restricted to admin users
- ✅ Bucket creation and management working
- ✅ Public bucket access configured

---

**Setup Complete**: All user accounts are operational with proper role-based permissions! 🎉
