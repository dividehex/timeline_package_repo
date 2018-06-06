#cloud-config
runcmd: 
  - "mkdir -p ${EFS_DIR}"
  - "echo \"${EFS_DNS_NAME}:/ ${EFS_DIR} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev,noresvport 0 0\" >> /etc/fstab"
  - "mount -a -t nfs4 defaults"
  - "aws s3 cp s3://${S3_BUCKET}/manifest.yml /manifest.yml"
  - "aws s3 cp s3://${S3_BUCKET}/scripts/bootstrap.py /bootstrap.py"
  - "/usr/bin/python3 /bootstrap.py"
