resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"

  tags = "${merge(
    map(
      "Name", "${var.name}-vpc",
      "Environment", "${var.environment}",
      "ServiceName", "${var.service_name}",
    ),
    local.default_tags
  )}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(
    map(
      "Name", "${var.name}-igw",
      "Environment", "${var.environment}",
      "ServiceName", "${var.service_name}",
    ),
    local.default_tags
  )}"

  lifecycle {
    create_before_destroy = true
  }
}
