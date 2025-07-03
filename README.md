# OpenRepo Mare - MinIO Management Documentation & Tools

This repository contains comprehensive documentation and tools for managing MinIO in the OpenRepo project.

## 📁 Repository Structure

### Main Repository Files
- **MinIO Documentation**
  - `MINIO-MANAGEMENT-COMMANDS.md` - Complete MinIO management command reference
  - `MINIO-LOGIN-CREDENTIALS.md` - Login credentials and access information
  - `MINIO_ROLES_EXPLAINED.md` - Detailed explanation of MinIO roles and permissions
  - `MINIO-USER-ACCOUNTS.md` - User account management guide
  - `QUICK-REFERENCE.md` - Quick reference for common operations
  - `SETUP-COMPLETE.md` - Setup completion guide
  - `RESOLUTION_COMPLETE.md` - Resolution and troubleshooting guide
  - `AGENT-CAPABILITIES.md` - Agent capabilities documentation

- **Scripts and Tools**
  - `setup-minio.sh` - MinIO setup script
  - `test-minio.sh` - MinIO testing script
  - `test-all-users.sh` - Comprehensive user permission testing
  - `monitor-buckets.sh` - Bucket monitoring script

- **Configuration**
  - `config/` - MinIO configuration files including policies

### Submodule
- `openrepo/` - Original OpenRepo repository (submodule)
  - Contains the complete OpenRepo project source code
  - Reference to: https://github.com/openkilt/openrepo

## 🚀 Getting Started

### Clone this Repository
```bash
# Clone with submodules
git clone --recurse-submodules https://github.com/farahz12/openrepo-mare.git

# Or if already cloned
git submodule update --init --recursive
```

### MinIO Management
1. Review the comprehensive documentation in `MINIO-MANAGEMENT-COMMANDS.md`
2. Use the provided scripts for setup and testing
3. Check `QUICK-REFERENCE.md` for common operations

## 📚 Documentation Highlights

### Complete MinIO Management
- User creation and management
- Bucket operations (create, delete, permissions)
- Policy management (read-only, write-only, custom policies)
- Monitoring and troubleshooting
- Security configurations
- Testing and validation scripts

### Practical Examples
All documentation includes working examples with real commands and expected outputs.

## 🔧 Tools Included

- **Setup Scripts**: Automated MinIO configuration
- **Test Scripts**: Validate permissions and functionality
- **Monitoring Scripts**: Track bucket usage and user activity
- **Policy Templates**: Pre-configured security policies

## 📖 Quick Links

- [Complete MinIO Commands](./MINIO-MANAGEMENT-COMMANDS.md)
- [User Management](./MINIO-USER-ACCOUNTS.md)
- [Role Explanations](./MINIO_ROLES_EXPLAINED.md)
- [Quick Reference](./QUICK-REFERENCE.md)
- [Original OpenRepo](./openrepo/)

## 🤝 Contributing

This repository maintains both custom MinIO documentation and a reference to the original OpenRepo project through git submodules.

- **For MinIO documentation**: Edit files directly in this repository
- **For OpenRepo changes**: Contribute to the [original repository](https://github.com/openkilt/openrepo)

## 📜 License

This project maintains the same license as the original OpenRepo project. See the `openrepo/LICENSE` file for details.
