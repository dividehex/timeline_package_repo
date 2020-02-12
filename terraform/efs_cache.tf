resource "aws_efs_file_system" "efs_cache" {
  creation_token = "timeline_repo"

  tags = {
    Name = "timeline_repo_efs_cache_volume"
  }
}

resource "aws_security_group" "timeline_repo_efs_security_group" {
  name        = "Timeline Repo EFS Security Group"
  description = "Limit traffic for Timeline Repo EFS cache"

  # TODO: tighten up in and out 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.timeline_repo_security_group.id}"]
  }

  vpc_id = data.aws_vpc.relops_vpc.id
}

resource "aws_efs_mount_target" "efs_cache_us_west_2c" {
  file_system_id = aws_efs_file_system.efs_cache.id
  # TODO: source subnet properly
  subnet_id       = "subnet-2c9be976"
  security_groups = ["${aws_security_group.timeline_repo_efs_security_group.id}"]
}
