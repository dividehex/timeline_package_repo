# Nightly event to trigger lambda
resource "aws_cloudwatch_event_rule" "nightly" {
  name        = "schedule_timeline_repo_mirror_sync"
  description = "Triggers the Timeline Repo lambda nightly"
  # cron nightly around 2am PST/9am UTC (aka mozilla time)
	schedule_expression = "cron(0 9 * * ? *)"
  is_enabled = true
}

# Cloudwatch group for docker container logs
resource "aws_cloudwatch_log_group" "docker_group" {
  name = "tlpr_docker_logs"
}

