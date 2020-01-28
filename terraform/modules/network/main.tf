locals {
  tags = "${
    merge(
      local.default_tags,
      var.default_tags
    )
  }"
}

resource "aws_subnet" "subnet" {
  count             = "${length(var.subnets)}"
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${var.subnets[count.index]}"
  availability_zone = "${var.availability_zones[count.index]}"

  tags = "${merge(
    map(
      "Name", "${var.subnet_type}-${var.name}",
      "Application", "${var.name}",
      "Network", "${var.network}",
      "Environment", "${var.environment}",
      "ServiceName", "${var.service_name}"
    ),
    local.tags
  )}"

  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
}

resource "aws_network_acl" "acl_pub" {
  vpc_id     = "${var.vpc_id}"
  subnet_ids = ["${aws_subnet.subnet.0.id}"]
  count      = "${var.public}"

  tags = "${merge(
    map(
      "Name", "PubNetworkAcl${var.subnet_count}-${var.name}",
      "Application", "${var.name}",
      "Network", "${var.network}",
      "Environment", "${var.environment}",
      "ServiceName", "${var.service_name}"
    ),
    local.tags
  )}"
}

resource "aws_network_acl_rule" "acl_ingress_all_pub" {
  count = "${var.public}"

  network_acl_id = "${aws_network_acl.acl_pub[0].id}"
  rule_number    = 100
  egress         = false
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "acl_all_egress_pub" {
  count = "${var.public}"

  network_acl_id = "${aws_network_acl.acl_pub[0].id}"
  rule_number    = 100
  egress         = true
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl" "acl_pri" {
  vpc_id     = "${var.vpc_id}"
  subnet_ids = ["${aws_subnet.subnet.0.id}"]
  count      = "${var.private}"

  tags = "${merge(
    map(
      "Name", "PriNetworkAcl${var.subnet_count}-${var.name}",
      "Application", "${var.name}",
      "Network", "${var.network}",
      "Environment", "${var.environment}",
      "ServiceName", "${var.service_name}"
    ),
    local.tags
  )}"
}

resource "aws_network_acl_rule" "acl_ingress_all_pri" {
  count = "${var.private}"

  network_acl_id = "${aws_network_acl.acl_pri[0].id}"
  rule_number    = 100
  egress         = false
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "acl_all_egress_pri" {
  count = "${var.private}"

  network_acl_id = "${aws_network_acl.acl_pri[0].id}"
  rule_number    = 100
  egress         = true
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_route_table" "rtb_pub" {
  vpc_id = "${var.vpc_id}"
  count  = "${var.public}"

  tags = "${merge(
    map(
      "Name", "PubRouteTable${var.subnet_count}-${var.name}",
      "Application", "${var.name}",
      "Network", "${var.network}",
      "Environment", "${var.environment}",
      "ServiceName", "${var.service_name}"
    ),
    local.tags
  )}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "rtba_pub" {
  count          = "${var.public}"
  subnet_id      = "${element(aws_subnet.subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.rtb_pub[0].id}"
}

resource "aws_route_table" "rtb_pri" {
  count  = "${var.private}"
  vpc_id = "${var.vpc_id}"

  tags = "${merge(
    map(
      "Name", "PriRouteTable${var.subnet_count}-${var.name}",
      "Application", "${var.name}",
      "Network", "${var.network}",
      "Environment", "${var.environment}",
      "ServiceName", "${var.service_name}"
    ),
    local.tags
  )}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "rtba_pri" {
  count          = "${var.private}"
  subnet_id      = "${element(aws_subnet.subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.rtb_pri[0].id}"
}
