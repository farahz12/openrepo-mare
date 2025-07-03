# MinIO Management Commands - Complete Guide

This guide provides all the commands you need to manage MinIO users, permissions, and bucket policies in your OpenRepo setup.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [User Management](#user-management)
- [Permission Management](#permission-management)
- [Bucket Management](#bucket-management)
- [Policy Management](#policy-management)
- [Monitoring Commands](#monitoring-commands)
- [Troubleshooting](#troubleshooting)
- [Examples](#examples)

## 🚀 Prerequisites

Before running any commands, ensure MinIO is running and you have admin access:

```bash
# Check if MinIO is running
docker ps | grep openrepo-minio

# Set up admin connection (required for all admin operations)
docker exec openrepo-minio mc alias set admin-conn http://localhost:9000 openrepo_minio_admin 'OpenRepo_MinIO_2024_Secure!'
```

## 👥 User Management

### Create a New User

```bash
# Create a new user
docker exec openrepo-minio mc admin user add admin-conn <username> '<password>'

# Example: Create a new developer
docker exec openrepo-minio mc admin user add admin-conn john-developer 'JohnSecure2024!'
```

### List All Users

```bash
# List all users and their status
docker exec openrepo-minio mc admin user list admin-conn
```

### Get User Information

```bash
# Get detailed user information
docker exec openrepo-minio mc admin user info admin-conn <username>

# Example
docker exec openrepo-minio mc admin user info admin-conn openrepo-developer
```

### Enable/Disable User

```bash
# Disable a user
docker exec openrepo-minio mc admin user disable admin-conn <username>

# Enable a user
docker exec openrepo-minio mc admin user enable admin-conn <username>

# Example
docker exec openrepo-minio mc admin user disable admin-conn john-developer
docker exec openrepo-minio mc admin user enable admin-conn john-developer
```

### Delete User

```bash
# Delete a user (be careful!)
docker exec openrepo-minio mc admin user remove admin-conn <username>

# Example
docker exec openrepo-minio mc admin user remove admin-conn john-developer
```

## 🔐 Permission Management

### List Available Policies

```bash
# Show all available policies
docker exec openrepo-minio mc admin policy list admin-conn
```

Available built-in policies:
- `readonly` - Read-only access to all buckets (includes download)
- `readwrite` - Full read/write access to all buckets  
- `writeonly` - Write-only access (upload only)
- `consoleAdmin` - MinIO console administration access
- `diagnostics` - System diagnostics access
- `agent-readonly` - Custom read-only with ListBucket (can download files, list buckets/objects)

### Attach Policy to User

```bash
# Attach a policy to a user
docker exec openrepo-minio mc admin policy attach admin-conn <policy-name> --user <username>

# Examples:
# Give full read/write access
docker exec openrepo-minio mc admin policy attach admin-conn readwrite --user john-developer

# Give read-only access
docker exec openrepo-minio mc admin policy attach admin-conn readonly --user jane-monitor

# Give console admin access
docker exec openrepo-minio mc admin policy attach admin-conn consoleAdmin --user john-developer
```

### Detach Policy from User

```bash
# Remove a policy from a user
docker exec openrepo-minio mc admin policy detach admin-conn <policy-name> --user <username>

# Example
docker exec openrepo-minio mc admin policy detach admin-conn readwrite --user john-developer
```

### Create Custom Policy

```bash
# 1. Create policy file (example for limited bucket access)
cat > /tmp/limited-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::openrepo-uploads",
        "arn:aws:s3:::openrepo-uploads/*",
        "arn:aws:s3:::openrepo-artifacts",
        "arn:aws:s3:::openrepo-artifacts/*"
      ]
    }
  ]
}
EOF

# 2. Copy policy to MinIO container
docker cp /tmp/limited-policy.json openrepo-minio:/tmp/limited-policy.json

# 3. Create the policy in MinIO
docker exec openrepo-minio mc admin policy create admin-conn limited-access /tmp/limited-policy.json

# 4. Attach to user
docker exec openrepo-minio mc admin policy attach admin-conn limited-access --user username
```

## 🪣 Bucket Management

### Create Bucket

```bash
# Create a new bucket
docker exec openrepo-minio mc mb admin-conn/<bucket-name>

# Example
docker exec openrepo-minio mc mb admin-conn/my-new-bucket
```

### List Buckets

```bash
# List all buckets
docker exec openrepo-minio mc ls admin-conn/
```

### Delete Bucket

```bash
# Delete empty bucket
docker exec openrepo-minio mc rb admin-conn/<bucket-name>

# Delete bucket and all contents (be careful!)
docker exec openrepo-minio mc rb admin-conn/<bucket-name> --force

# Example
docker exec openrepo-minio mc rb admin-conn/my-new-bucket
```

### Make Bucket Public (Anonymous Read Access)

```bash


docker exec openrepo-minio mc anonymous set public admin-conn/<bucket-name>

# Example

docker exec openrepo-minio mc anonymous set public admin-conn/openrepo-artifacts #hedhyy assa7

```

### Make Bucket Private

```bash

docker exec openrepo-minio mc anonymous set none admin-conn/<bucket-name>

# Example

docker exec openrepo-minio mc anonymous set none admin-conn/openrepo-artifacts
```

### Check Bucket Access Policy

```bash
# Check bucket anonymous access policy
docker exec openrepo-minio mc anonymous get admin-conn/<bucket-name>


# Example
docker exec openrepo-minio mc anonymous get admin-conn/openrepo-artifacts
```

### Set Bucket to Download-Only (Public Download, No List)

```bash
# Allow public downloads but not listing
docker exec openrepo-minio mc anonymous set download admin-conn/<bucket-name>

# Example
docker exec openrepo-minio mc anonymous set download admin-conn/openrepo-releases
```

## 📜 Policy Management

### Create Read-Only Policy for Specific Buckets

```bash
# Create policy file
cat > /tmp/readonly-specific.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::openrepo-releases",
        "arn:aws:s3:::openrepo-releases/*",
        "arn:aws:s3:::openrepo-artifacts",
        "arn:aws:s3:::openrepo-artifacts/*"
      ]
    }
  ]
}
EOF

# Apply the policy
docker cp /tmp/readonly-specific.json openrepo-minio:/tmp/readonly-specific.json
docker exec openrepo-minio mc admin policy create admin-conn readonly-releases /tmp/readonly-specific.json
```

### Create Upload-Only Policy

```bash
# Create upload-only policy file
cat > /tmp/upload-only.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::openrepo-uploads/*"
      ]
    }
  ]
}
EOF

# Apply the policy
docker cp /tmp/upload-only.json openrepo-minio:/tmp/upload-only.json
docker exec openrepo-minio mc admin policy create admin-conn upload-only /tmp/upload-only.json
```

### Delete Custom Policy

```bash
# Delete a custom policy
docker exec openrepo-minio mc admin policy remove admin-conn <policy-name>

# Example
docker exec openrepo-minio mc admin policy remove admin-conn upload-only
```

## 📊 Monitoring Commands

### Check System Status

```bash
# System info
docker exec openrepo-minio mc admin info admin-conn

# Service status
docker exec openrepo-minio mc admin service status admin-conn
```

### Monitor User Activity

```bash
# List user sessions
docker exec openrepo-minio mc admin user list admin-conn

# Check bucket usage
docker exec openrepo-minio mc du admin-conn/

# Check specific bucket usage
docker exec openrepo-minio mc du admin-conn/openrepo-packages
```

## 🧪 Testing Commands

### Test User Access

```bash
# Test user login
docker exec openrepo-minio mc alias set test-user http://localhost:9000 <username> '<password>'

# Test bucket listing
docker exec openrepo-minio mc ls test-user/

# Test file download (for users with read access)
docker exec openrepo-minio mc cp test-user/bucket-name/file.txt /tmp/downloaded-file.txt

# Test file upload (for users with write access)
docker exec openrepo-minio mc cp /etc/hostname test-user/bucket-name/test-file.txt

# Test file deletion (for users with write access)
docker exec openrepo-minio mc rm test-user/bucket-name/test-file.txt
```

### Test All Users (Using Our Script)

```bash
# Run comprehensive permission tests
./test-all-users.sh
```

## 🔧 Troubleshooting

### Reset User Password

```bash
# Remove user and recreate (MinIO doesn't have password change)
docker exec openrepo-minio mc admin user remove admin-conn <username>
docker exec openrepo-minio mc admin user add admin-conn <username> '<new-password>'

# Re-attach policies
docker exec openrepo-minio mc admin policy attach admin-conn <policy-name> --user <username>
```

### Fix Permission Issues

```bash
# Check user policies
docker exec openrepo-minio mc admin user info admin-conn <username>

# Remove all policies and re-add
docker exec openrepo-minio mc admin policy detach admin-conn <policy-name> --user <username>
docker exec openrepo-minio mc admin policy attach admin-conn <correct-policy> --user <username>
```

### Restore Default Permissions

```bash
# For admin user
docker exec openrepo-minio mc admin policy attach admin-conn readwrite --user openrepo-admin
docker exec openrepo-minio mc admin policy attach admin-conn consoleAdmin --user openrepo-admin

# For developer
docker exec openrepo-minio mc admin policy attach admin-conn readwrite --user openrepo-developer

# For agent
docker exec openrepo-minio mc admin policy attach admin-conn agent-readonly --user openrepo-agent
```

## 📝 Complete Examples

### Example 1: Create New Developer User

```bash
# 1. Create user
docker exec openrepo-minio mc admin user add admin-conn sarah-dev 'SarahSecure2024!'

# 2. Give read/write access
docker exec openrepo-minio mc admin policy attach admin-conn readwrite --user sarah-dev

# 3. Test access
docker exec openrepo-minio mc alias set sarah-test http://localhost:9000 sarah-dev 'SarahSecure2024!'
docker exec openrepo-minio mc ls sarah-test/

# 4. Verify permissions
docker exec openrepo-minio mc admin user info admin-conn sarah-dev
```

### Example 2: Create Monitor User (Read-Only)

```bash
# 1. Create user
docker exec openrepo-minio mc admin user add admin-conn monitor-user 'MonitorSecure2024!'

# 2. Give read-only access
docker exec openrepo-minio mc admin policy attach admin-conn agent-readonly --user monitor-user

# 3. Test read capabilities
docker exec openrepo-minio mc alias set monitor-test http://localhost:9000 monitor-user 'MonitorSecure2024!'

# Can list buckets and download files
docker exec openrepo-minio mc ls monitor-test/
docker exec openrepo-minio mc cp monitor-test/openrepo-public/somefile.txt /tmp/downloaded.txt

# 4. Test that write operations fail
docker exec openrepo-minio mc mb monitor-test/should-fail  # This should fail
docker exec openrepo-minio mc cp /etc/hostname monitor-test/openrepo-public/upload-test.txt  # This should fail
```

### Example 3: Create Upload-Only User

```bash
# 1. Create custom upload-only policy (see Policy Management section)
cat > /tmp/upload-only.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:PutObject"],
      "Resource": ["arn:aws:s3:::openrepo-uploads/*"]
    }
  ]
}
EOF

# 2. Apply policy
docker cp /tmp/upload-only.json openrepo-minio:/tmp/upload-only.json
docker exec openrepo-minio mc admin policy create admin-conn upload-only /tmp/upload-only.json

# 3. Create user and attach policy
docker exec openrepo-minio mc admin user add admin-conn uploader 'UploaderSecure2024!'
docker exec openrepo-minio mc admin policy attach admin-conn upload-only --user uploader
```

### Example 4: Make Multiple Buckets Public

```bash
# Make several buckets public for downloads
./make-bucket-public.sh public openrepo-artifacts
./make-bucket-public.sh public openrepo-releases
./make-bucket-public.sh public openrepo-uploads

# Verify they are public
./make-bucket-public.sh status openrepo-artifacts
./make-bucket-public.sh status openrepo-releases
./make-bucket-public.sh status openrepo-uploads
```

### Example 5: Bulk User Management

```bash
# Create multiple users
users=("alice-dev" "bob-tester" "charlie-ops")
passwords=("AliceSecure2024!" "BobSecure2024!" "CharlieSecure2024!")

for i in "${!users[@]}"; do
    user="${users[$i]}"
    pass="${passwords[$i]}"
    
    echo "Creating user: $user"
    docker exec openrepo-minio mc admin user add admin-conn "$user" "$pass"
    docker exec openrepo-minio mc admin policy attach admin-conn readwrite --user "$user"
done

# List all users to verify
docker exec openrepo-minio mc admin user list admin-conn
```

## 🎯 Quick Reference Commands

```bash
# User Management
docker exec openrepo-minio mc admin user add admin-conn <user> '<pass>'
docker exec openrepo-minio mc admin user list admin-conn
docker exec openrepo-minio mc admin user remove admin-conn <user>

# Permission Management  
docker exec openrepo-minio mc admin policy attach admin-conn <policy> --user <user>
docker exec openrepo-minio mc admin policy detach admin-conn <policy> --user <user>
docker exec openrepo-minio mc admin policy list admin-conn

# Bucket Management
docker exec openrepo-minio mc mb admin-conn/<bucket>
docker exec openrepo-minio mc ls admin-conn/
./make-bucket-public.sh public <bucket>
./make-bucket-public.sh private <bucket>

# Testing
./test-all-users.sh
docker exec openrepo-minio mc alias set test http://localhost:9000 <user> '<pass>'
```

---

## 🔗 Related Documentation

- [User Accounts Overview](MINIO-USER-ACCOUNTS.md)
- [Role Explanations](MINIO_ROLES_EXPLAINED.md)
- [Console Guide](MINIO-CONSOLE-GUIDE.md)
- [Quick Reference](QUICK-REFERENCE.md)

**This guide covers all the essential MinIO management commands you'll need for your OpenRepo setup!** 🚀
