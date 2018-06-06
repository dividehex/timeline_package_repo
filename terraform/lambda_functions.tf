data "archive_file" "launch_mirror_sync_lambda_zip" {
    type        = "zip"
    source_dir  = "${path.module}/lambda_sources/launch_mirror_sync"
    output_path = "${path.module}/lambda_packages/launch_mirror_sync.zip"
}

resource "aws_lambda_function" "timeline_repo_mirror_sync" {
  function_name = "timeline_repo_mirror_sync"
  description = "Launches an ec2 instance to sync mirrors"

  filename = "${path.module}/lambda_packages/launch_mirror_sync.zip"
  handler = "launch_mirror_sync.lambda_handler"
  runtime = "python3.6"
  timeout = "60"
  source_code_hash = "${data.archive_file.launch_mirror_sync_lambda_zip.output_base64sha256}"
  role = "${aws_iam_role.lambda_exec.arn}"
}

# Allow cloudwatch to trigger the lambda function
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id   = "AllowExecutionFromCloudWatch"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.timeline_repo_mirror_sync.function_name}"
  principal      = "events.amazonaws.com"
  source_arn     = "${aws_cloudwatch_event_rule.nightly.arn}"
#  qualifier      = "${aws_lambda_alias.test_alias.name}"
}

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_exec" {
  name = "timeline_repo_lambda_assume_role"
  assume_role_policy =  "${data.aws_iam_policy_document.lambda_assume_role.json}"
}

# IAM role policy which allows lambda to access ec2
resource "aws_iam_role_policy" "allow_lambda_ec2_access" {
  name = "timeline_repo_lambda_ec2_access"
  role = "${aws_iam_role.lambda_exec.id}"
	policy = "${data.aws_iam_policy_document.timeline_repo_lambda_access_policy.json}"
}

# TODO: add cloudwatch log for lamda
