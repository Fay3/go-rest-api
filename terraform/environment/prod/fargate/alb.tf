resource "aws_alb" "lb" {

  name            = "ALB-${var.name}"
  count           = length(module.Public1.subnet_ids)
  subnets         = ["${module.Public1.subnet_ids.0[count.index]}", "${module.Public2.subnet_ids.0[count.index]}"]
  security_groups = ["${aws_security_group.sg_alb.id}"]

  access_logs {
    bucket  = "${var.name}-alb-logs"
    prefix  = "alb-log"
    enabled = true
  }
}

resource "aws_alb_target_group" "alb_tg" {
  name        = "ALBTARGETGROUP-${var.name}"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.vpc.id}"
  target_type = "ip"
}

resource "aws_alb_listener" "alb_ln" {
  load_balancer_arn = "${aws_alb.lb.0.id}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:eu-west-1:${var.aws_account_id}:certificate/97112dba-4948-4ff9-9ba2-c3b9e05476dc"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_tg.id}"
    type             = "forward"
  }
}

resource "aws_s3_bucket" "alb_log_bucket" {
  bucket = "${var.name}-alb-logs"
  acl    = "private"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${var.s3_log_bucket_name}"
    target_prefix = "${var.name}-alb-logs/"
  }

  tags = "${merge(
    map(
      "Name", "${var.name}-alb-logs",
      "Environment", "${var.environment}",
      "ServiceName", "${var.service_name}"
    ),
    local.default_tags
  )}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_policy" "alb_log_bucket_policy" {
  bucket = "${aws_s3_bucket.alb_log_bucket.id}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
       {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.aws_account_id}:root"
            },
            "Action": [
                "s3:PutBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${var.name}-alb-logs/alb-log/AWSLogs/*"
            ]
        }
    ]
}
POLICY
}
