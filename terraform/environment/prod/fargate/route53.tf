# resource "aws_route53_record" "cname_alb" {
#   zone_id = "${var.route53_hosted_zone}"
#   name    = "go-rest-api.stevenquan.co.uk"
#   type    = "CNAME"
#   ttl     = "60"
#   records = ["${aws_lb.lb.dns_name}"]
# }

# resource "aws_route53_record" "alias_route53_record" {
#   zone_id = "${var.route53_hosted_zone}"
#   name    = "go-rest-api.stevenquan.co.uk"
#   type    = "A"

#   alias {
#     name                   = "${aws_lb.lb.dns_name}"
#     zone_id                = "${aws_lb.lb.zone_id}"
#     evaluate_target_health = true
#   }
# }
