# Nightly event to trigger lambda
resource "aws_cloudwatch_event_rule" "nightly" {
  name        = "schedule_timeline_repo_mirror_sync"
  description = "Triggers the Timeline Repo lambda nightly"
  # TODO: set to cron nightly around 2am PST (aka mozilla time)
	schedule_expression = "rate(5 minutes)"
  is_enabled = false
}

# Cloudwatch group for docker container logs
resource "aws_cloudwatch_log_group" "docker_group" {
  name = "tlpr_docker_logs"
}

