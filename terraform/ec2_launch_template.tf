data "aws_ami" "latest_ami" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["tlpr-*"]
  }
}


resource "aws_launch_template" "timeline_repo_ec2_launch_template" {
  name = "timeline_repo_ec2_launch_template"

  ebs_optimized = false

  iam_instance_profile {
    name = aws_iam_instance_profile.tlpr_instance_profile.name
  }

  image_id                             = data.aws_ami.latest_ami.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t2.medium"

  # TODO: change key
  key_name = "jwatkins_id_rsa_mozilla_2017-05-15"

  network_interfaces {
    associate_public_ip_address = true
    # TODO: source subnet properly
    subnet_id             = "subnet-2c9be976"
    delete_on_termination = true
    security_groups       = ["${aws_security_group.timeline_repo_security_group.id}"]
  }

  user_data = base64encode("${data.template_file.user_data_source.rendered}")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "timeline_repo_mirror_sync"
    }
  }
}

data "template_file" "user_data_source" {
  template = file("${path.module}/templates/user_data.yml.tpl")

  vars = {
    S3_BUCKET    = aws_s3_bucket.s3_bucket.id
    EFS_DNS_NAME = aws_efs_file_system.efs_cache.dns_name
    EFS_DIR      = "/data"
  }
}


