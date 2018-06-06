# Create role policy from ec2 instance policy data source and attach it to the ec2 assume role
resource "aws_iam_role_policy" "allow_ec2_s3_access_policy" {
    name = "timeline_repo_s3_policy"
    role = "${aws_iam_role.ec2_assume_role.id}"
    policy = "${data.aws_iam_policy_document.ec2_instance_policy.json}"
}

# Create ec2 assume role from the ec2 assume role policy data source
resource "aws_iam_role" "ec2_assume_role" {
    name = "ec2_repo_assume_role"
    assume_role_policy = "${data.aws_iam_policy_document.ec2_assume_role.json}"
}

# Create instance profile and attach ec2 assume role
resource "aws_iam_instance_profile" "tlpr_instance_profile" {
    name = "tlpr_instance_profile"
    role = "${aws_iam_role.ec2_assume_role.name}"
}

