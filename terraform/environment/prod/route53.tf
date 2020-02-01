resource "aws_route53_record" "alias_route53_record" {
  zone_id = "${var.route53_hosted_zone}"
  name    = "${var.fqdn}"
  type    = "A"

  alias {
    name                   = "${aws_alb.app_lb.0.dns_name}"
    zone_id                = "${aws_alb.app_lb.0.zone_id}"
    evaluate_target_health = true
  }
}
