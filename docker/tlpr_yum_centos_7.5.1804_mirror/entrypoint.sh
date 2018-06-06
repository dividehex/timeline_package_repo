#!/bin/sh

mkdir -p /data/repos/centos_7.5.1804

# Run rsync to mirror repo to NFS cache mount '/data/'
/usr/bin/rsync rsync://mirrors.kernel.org/centos/7.5.1804/ /data/repos/centos_7.5.1804 -av --delete

# Sync the entire. aws cli supports sync 'aka delta copy' similar to rsync
/usr/bin/aws s3 sync /data/repos/centos_7.5.1804/  s3://relops-tlpr/repos/centos_7.5.1804/centos_7.5.1804_latest --no-progress --delete

# Optionally, generate a version manifest for building snapshots 'post ex facto'
