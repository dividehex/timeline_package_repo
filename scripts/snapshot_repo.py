#!/usr/bin/env python3
import argparse
import boto3
import shlex
import os
from datetime import datetime
from awscli.clidriver import create_clidriver


def main():
    parser = argparse.ArgumentParser()

    parser.add_argument("repo", help="repo name to snapshot")
    parser.add_argument("-b", "--bucket", help="bucket name", default="relops-tlpr")
    parser.add_argument("-n", "--dryrun", help="dry run", default=False, action="store_true")
    
    args = parser.parse_args()

    print(args)

    source_s3_uri, target_s3_uri = build_uris(args.repo, args.bucket)
    exec_sync(source_s3_uri, target_s3_uri, args.dryrun)

def build_uris(repo_name, bucket):
    source_s3_uri = "s3://{}/repos/{}/{}_latest".format(bucket, repo_name, repo_name)
    target_s3_uri = "s3://{}/repos/{}/{}_{}".format(bucket, repo_name, repo_name, datetime.utcnow().isoformat())

    print(source_s3_uri, target_s3_uri)
    return source_s3_uri, target_s3_uri

def exec_sync(source_s3_uri, target_s3_uri, dryrun):
    cmd = "s3 sync {} {}".format(source_s3_uri, target_s3_uri)
    if dryrun:
        cmd = cmd + " --dryrun"
    print(cmd)
    aws_cli(shlex.split(cmd))


def aws_cli(*cmd):
    old_env = dict(os.environ)
    try:

        # Environment
        env = os.environ.copy()
        env['LC_CTYPE'] = u'en_US.UTF'
        os.environ.update(env)
        print(*cmd)
        # Run awscli in the same process
        exit_code = create_clidriver().main(*cmd)

        # Deal with problems
        if exit_code > 0:
            raise RuntimeError('AWS CLI exited with code {}'.format(exit_code))
    finally:
        os.environ.clear()
        os.environ.update(old_env)

if __name__ == "__main__":
    # execute only if run as a script
    main()
