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
        ]
        # TODO: Limit this
        resources = [
            "*",
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
            "iam:PassRole",
            "ec2:*",
        ]
        # TODO: limit this
        resources = [ "*" ]
    }
}


data "aws_vpc" "relops_vpc" {
  filter {
    name   = "tag:Name"
    values = ["relops-vpc"]
  }
}
