resource "aws_alb" "lb" {

  name            = "ALB-${var.name}"
  count           = length(module.Public1.subnet_ids)
  subnets         = ["${module.Public1.subnet_ids.0[count.index]},${module.Public2.subnet_ids.0[count.index]}"]
  security_groups = ["${aws_security_group.sg_alb.id}"]

  access_logs {
    bucket  = "go-rest-api-s3-log"
    prefix  = "go-rest-api-app-lb"
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
