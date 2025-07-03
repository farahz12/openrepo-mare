# MinIO Login Credentials - Quick Reference

## 🌐 MinIO Console Access

**URL**: http://localhost:9001

**Login Credentials**:
- **Username**: `openrepo_minio_admin`
- **Password**: `OpenRepo_MinIO_2024_Secure!`

## ✅ Current Status

- MinIO Container: ✅ Running and Healthy
- Console Access: ✅ Available at port 9001
- Credentials: ✅ Verified and Working

## 🎯 Quick Actions

### Making Buckets Public via Console:
1. Login to http://localhost:9001
2. Navigate to **Buckets**
3. Click on your bucket name
4. Look for **"Access Policy"** or **"Anonymous"** tab
5. Set policy to **"readonly"** for public access

### Command Line Alternative:
```bash
# Create bucket and make it public
docker exec openrepo-minio mc mb test-connection/my-bucket
docker exec openrepo-minio mc anonymous set public test-connection/my-bucket

# Check bucket policy
docker exec openrepo-minio mc anonymous get test-connection/my-bucket
```

## 🔧 Troubleshooting

If login still fails:
1. Wait 30 seconds for container to fully start
2. Try refreshing the browser page
3. Clear browser cache/cookies
4. Restart MinIO: `docker-compose -f docker-compose.prod.yml restart minio`

---
**Last Updated**: Container restarted with correct credentials ✅
