resource "aws_security_group" "timeline_repo_security_group" {
  name        = "Timeline Repo Security Group"
  description = "Limit traffic for Timeline Repo ec2 worker"

  # TODO: tighten up both in and out
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # TODO: source vpc_id properly
  vpc_id = "vpc-086b6d71"

#  tags {
#    Name = "allow_all"
#  }
}
