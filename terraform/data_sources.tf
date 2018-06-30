# Data source of ec2 instance policy
data "aws_iam_policy_document" "ec2_instance_policy" {
    # Read access timeline_repo S3 bucket
    statement = {
        effect = "Allow"
        actions = [
            "s3:Get*",
            "s3:List*",
        ]
        resources = [
			"${aws_s3_bucket.s3_bucket.arn}/*"
        ]
    }

    # Read/Write access
    statement = {
        effect = "Allow"
        actions = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject",
        ]
        resources = [
            "${aws_s3_bucket.s3_bucket.arn}/*",
        ]
    }

    # Allow docker to write to cloud watch
    statement = {
        effect = "Allow"
        actions = [
            "logs:PutLogEvents",
            "logs:CreateLogStream",
            "logs:DescribeLogStreams",
        ]
        resources = [
            "${aws_cloudwatch_log_group.docker_group.arn}",
        ]
    }

}

# IAM policy to allow ec2 instance to assume role
data "aws_iam_policy_document" "ec2_assume_role" {
    statement {
        actions = ["sts:AssumeRole"]
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

# IAM policy to allow lambda to assume role
data "aws_iam_policy_document" "lambda_assume_role" {
    statement {
        actions = ["sts:AssumeRole"]
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }
    }
}

# IAM policy to allow lamda function to access ec2
data "aws_iam_policy_document" "timeline_repo_lambda_access_policy" {
    statement = {
        actions = [
            "ec2:*",
        ]
        resources = [ "*" ]
    }

    statement = {
        actions = [
            "iam:PassRole",
        ]
        resources = [ "arn:aws:iam::${data.aws_caller_identity.releng_account.account_id}:role/*" ]
    }
}

# Account ID
data "aws_caller_identity" "releng_account" {}

data "aws_vpc" "relops_vpc" {
  filter {
    name   = "tag:Name"
    values = ["relops-vpc"]
  }
}

data "aws_subnet_ids" "example" {
  vpc_id = "${data.aws_vpc.relops_vpc.id}"
}

