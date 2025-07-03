# 🔐 MinIO User Roles & Permissions Explained

## 🏛️ **Root Administrator**
### `openrepo_minio_admin` / `OpenRepo_MinIO_2024_Secure!`

**Purpose**: System-level administration
**Access Level**: Root (Full system control)
**Interface**: MinIO Console (http://localhost:9001)

**Capabilities**:
- ✅ **System Management**: Create/delete users, modify policies, configure server
- ✅ **Full Bucket Control**: Create, delete, configure any bucket
- ✅ **User Management**: Add/remove users, assign/revoke permissions
- ✅ **Policy Management**: Create custom policies, modify access rules
- ✅ **Monitoring**: View system metrics, logs, performance data
- ✅ **Configuration**: Change server settings, security policies
- ✅ **Data Access**: Read/write/delete ANY file in ANY bucket

**When to Use**:
- Initial system setup
- User management tasks
- System troubleshooting
- Security configuration
- Emergency access

---

## 👑 **Application Administrator**
### `openrepo-admin` / `AdminSecure2024!`

**Purpose**: Application-level administration for OpenRepo
**Access Level**: Full data access with `readwrite` policy
**Interface**: API/CLI/Applications

**Capabilities**:
- ✅ **All Buckets**: Full read/write access to ALL buckets
- ✅ **File Operations**: Upload, download, delete, modify any file
- ✅ **Bucket Contents**: List and manage contents of all buckets
- ✅ **Batch Operations**: Bulk file operations, sync operations
- ❌ **User Management**: Cannot create/delete MinIO users
- ❌ **System Config**: Cannot modify MinIO server settings

**Bucket Access**:
```
openrepo-artifacts  ✅ Read/Write (build outputs, packages)
openrepo-uploads    ✅ Read/Write (temporary files)
openrepo-releases   ✅ Read/Write (release packages)
openrepo-repos      ✅ Read/Write (source repositories)
openrepo-logs       ✅ Read/Write (application logs)
openrepo-backups    ✅ Read/Write (system backups)
```

**Typical Use Cases**:
- OpenRepo application backend
- Administrative scripts
- Data migration/backup
- Content management
- Emergency data recovery

---

## 🛠️ **Developer**
### `openrepo-developer` / `DevSecure2024!`

**Purpose**: Development and deployment operations
**Access Level**: Full data access with `readwrite` policy
**Interface**: API/CLI/Development tools

**Capabilities**:
- ✅ **Development Buckets**: Read/write to work-related buckets
- ✅ **CI/CD Operations**: Upload build artifacts, releases
- ✅ **Testing**: Upload test files, temporary data
- ✅ **Deployment**: Manage release packages
- ❌ **Sensitive Data**: Limited access to logs and backups
- ❌ **User Management**: Cannot manage MinIO users

**Bucket Access** (Same as Admin currently):
```
openrepo-artifacts  ✅ Read/Write (upload build results)
openrepo-uploads    ✅ Read/Write (development uploads)  
openrepo-releases   ✅ Read/Write (publish releases)
openrepo-repos      ✅ Read/Write (manage source code)
openrepo-logs       ✅ Read/Write (debug applications)
openrepo-backups    ✅ Read/Write (development backups)
```

**Typical Use Cases**:
- CI/CD pipelines
- Build system uploads
- Release management
- Development testing
- Code repository management

---

## 👀 **Read-Only Agent**
### `openrepo-agent` / `AgentSecure2024!`

**Purpose**: Monitoring, auditing, and read-only operations
**Access Level**: Read-only with `readonly` policy
**Interface**: API/CLI/Monitoring tools

**Capabilities**:
- ✅ **Read Access**: Download and view any file
- ✅ **List Contents**: Browse all bucket contents
- ✅ **Monitoring**: Check file sizes, dates, metadata
- ✅ **Backup Verification**: Verify backup contents
- ❌ **Write Operations**: Cannot upload, modify, or delete
- ❌ **Bucket Management**: Cannot create or configure buckets

**Bucket Access**:
```
openrepo-artifacts  📖 Read-Only (download packages)
openrepo-uploads    📖 Read-Only (view uploaded files)
openrepo-releases   📖 Read-Only (download releases)
openrepo-repos      📖 Read-Only (read source code)
openrepo-logs       📖 Read-Only (analyze logs)
openrepo-backups    📖 Read-Only (verify backups)
```

**Typical Use Cases**:
- Monitoring systems
- Backup verification scripts
- Audit tools
- Read-only integrations
- Public file access
- Download services

---

## 🌐 **Public Access (Anonymous)**

**Purpose**: Public file access without authentication
**Access Level**: Varies by bucket
**Interface**: Direct HTTP/Browser access

**Public Buckets** (No authentication required):
```
openrepo-artifacts  🌍 Public Read (http://localhost:9000/openrepo-artifacts/file.zip)
openrepo-uploads    🌍 Public Read (http://localhost:9000/openrepo-uploads/file.pdf)  
openrepo-releases   🌍 Public Read (http://localhost:9000/openrepo-releases/v1.0.0.tar.gz)
```

**Private Buckets** (Authentication required):
```
openrepo-repos      🔒 Private (requires user credentials)
openrepo-logs       🔒 Private (requires user credentials)
openrepo-backups    🔒 Private (requires user credentials)
```

---

## 🔗 **Role Hierarchy & Security**

```
🏛️  ROOT ADMIN (openrepo_minio_admin)
    ├── System configuration
    ├── User management  
    └── Emergency access
    
👑  APP ADMIN (openrepo-admin)
    ├── Full data operations
    ├── Application management
    └── Data recovery
    
🛠️  DEVELOPER (openrepo-developer)  
    ├── Development operations
    ├── CI/CD integration
    └── Release management
    
👀  AGENT (openrepo-agent)
    ├── Monitoring & auditing
    ├── Read-only access
    └── Backup verification
    
🌍  PUBLIC (anonymous)
    └── Public file downloads
```

## 💡 **Best Practices**

1. **Use Root Admin** only for:
   - Initial setup
   - User management
   - System troubleshooting

2. **Use App Admin** for:
   - OpenRepo application
   - Data management scripts
   - Administrative tasks

3. **Use Developer** for:
   - CI/CD pipelines
   - Development tools
   - Release automation

4. **Use Agent** for:
   - Monitoring systems
   - Backup scripts
   - Read-only integrations

5. **Use Public Access** for:
   - Software downloads
   - Public artifacts
   - Documentation files
