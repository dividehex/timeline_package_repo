#!/bin/sh

mkdir -p /data/repos/xenial

# Run apt-mirror to mirror repos to NFS cache mount '/data/'
/usr/bin/apt-mirror /mirror.list

# Sync the entire. aws cli supports sync 'aka delta copy' similar to rsync
aws s3 sync /data/repos/xenial/archive.ubuntu.com/ubuntu  s3://relops-tlpr/repos/xenial/xenial_latest --no-progress --delete

# Optionally, generate a version manifest for building snapshots 'post ex facto'

echo "Finished"
