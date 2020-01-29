resource "aws_cloudwatch_log_group" "cw_log_group" {
  name = "${var.name}-log-group"

  tags = "${merge(
    map(
      "Name", "${var.name}-log-group",
      "Environment", "${var.environment}",
      "ServiceName", "${var.service_name}"
    ),
    local.default_tags
  )}"
}
