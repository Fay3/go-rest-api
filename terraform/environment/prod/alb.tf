resource "aws_alb" "app_lb" {

  name            = "ALB-${var.name}"
  count           = length(module.Public1.subnet_ids)
  subnets         = ["${module.Public1.subnet_ids.0[count.index]}", "${module.Public2.subnet_ids.0[count.index]}"]
  security_groups = ["${aws_security_group.sg_alb.id}"]

  access_logs {
    bucket  = "${var.name}-alb-logs"
    prefix  = "logs"
    enabled = true
  }

  tags = "${merge(
    map(
      "Name", "ALB-${var.name}",
      "Environment", "${var.environment}",
      "ServiceName", "${var.service_name}",
    ),
    local.default_tags
  )}"

  depends_on = [
    "aws_s3_bucket_policy.alb_log_bucket_policy",
  ]

}

resource "aws_alb_target_group" "alb_tg" {
  name        = "ALBTARGETGROUP-${var.name}"
  port        = "${var.app_port}"
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.vpc.id}"
  target_type = "ip"

  tags = "${merge(
    map(
      "Name", "ALB-TG-${var.name}",
      "Environment", "${var.environment}",
      "ServiceName", "${var.service_name}",
    ),
    local.default_tags
  )}"
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = "${aws_alb.app_lb.0.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "alb_ln" {
  load_balancer_arn = "${aws_alb.app_lb.0.id}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:${var.aws_region}:${var.aws_account_id}:certificate/${var.acm_certificate_id}"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_tg.id}"
    type             = "forward"
  }
}

resource "aws_s3_bucket" "alb_log_bucket" {
  bucket        = "${var.name}-alb-logs"
  acl           = "private"
  force_destroy = "true"

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

data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket_policy" "alb_log_bucket_policy" {
  bucket = "${aws_s3_bucket.alb_log_bucket.id}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
       {
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                  "${data.aws_elb_service_account.main.arn}"
                ]
            },
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.name}-alb-logs/*"
                ]
        }
    ]
}
POLICY
}
