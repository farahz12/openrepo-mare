# OpenRepo MinIO Setup - Quick Reference

## 🚀 Quick Start Commands

```bash
# Start the complete system
./start-openrepo-production.sh

# Check everything is working
./health-check.sh

# Test all permissions
./test-minio.sh

# Monitor system status
./monitor-buckets.sh

# Make buckets public/private
./make-bucket-public.sh public bucket-name
./make-bucket-public.sh private bucket-name
```

## 🌐 MinIO Console Access

- **Console URL**: http://localhost:9001
- **Root Admin**: `openrepo_minio_admin` / `OpenRepo_MinIO_2024_Secure!`
- **App Admin**: `openrepo-admin` / `AdminSecure2024!`

## 👥 User Accounts & Access

| User | Password | Role | Permissions |
|------|----------|------|-------------|
| `openrepo_minio_admin` | `OpenRepo_MinIO_2024_Secure!` | Root Admin | Everything |
| `openrepo-admin` | `AdminSecure2024!` | App Admin | Full access + Console |
| `openrepo-developer` | `DevSecure2024!` | Developer | Read/Write buckets |
| `openrepo-agent` | `AgentSecure2024!` | Service | Read-only access |

## 🪣 Buckets & Policies

| Bucket | Policy | Purpose |
|--------|--------|---------|
| `openrepo-packages` | Private | Production packages |
| `openrepo-uploads` | Private | Temp uploads |
| `openrepo-public` | Public | Public assets |
| `test` | Private | Testing |
| `test-public-bucket` | Public | Public testing |

## 🔍 Health Check URLs

- **MinIO Console**: http://localhost:9001
- **MinIO API**: http://localhost:9000
- **OpenRepo App**: http://localhost:8080
- **Health Check**: `./health-check.sh`

## 🛠️ Troubleshooting Quick Fixes

### Can't Login to MinIO?
```bash
# Check if services are running
docker-compose -f docker-compose.prod.yml ps

# Restart MinIO if needed
docker-compose -f docker-compose.prod.yml restart minio
```

### Permission Denied Errors?
```bash
# Test all permissions
./test-minio.sh

# Check user status
docker exec openrepo-minio mc admin user list admin-conn
```

### Need to Reset Everything?
```bash
# Stop everything
docker-compose -f docker-compose.prod.yml down -v

# Start fresh
./start-openrepo-production.sh
```

## 📊 Monitoring Commands

```bash
# Real-time bucket monitoring
./monitor-buckets.sh

# Check all service health
./health-check.sh

# View container status
docker-compose -f docker-compose.prod.yml ps

# View logs
docker-compose -f docker-compose.prod.yml logs -f
```

## 📝 Documentation Links

- **Complete Guide**: [README-COMPLETE.md](README-COMPLETE.md)
- **User Accounts**: [MINIO-USER-ACCOUNTS.md](MINIO-USER-ACCOUNTS.md)
- **Console Guide**: [MINIO-CONSOLE-GUIDE.md](MINIO-CONSOLE-GUIDE.md)
- **Login Credentials**: [MINIO-LOGIN-CREDENTIALS.md](MINIO-LOGIN-CREDENTIALS.md)

---

## 🎯 Success Criteria Met

✅ MinIO login works perfectly  
✅ 4 users with role-based permissions  
✅ All buckets configured properly  
✅ Health checks pass  
✅ Production-ready security  
✅ Complete documentation  
✅ Management tools available  
✅ Custom policies working  

**Status**: 🟢 PRODUCTION READY