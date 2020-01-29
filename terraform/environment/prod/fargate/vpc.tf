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


resource "aws_flow_log" "vpc_flow_log" {
  log_destination      = "${aws_s3_bucket.flow_log_bucket.arn}"
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = "${aws_vpc.vpc.id}"
}

resource "aws_s3_bucket" "flow_log_bucket" {
  bucket = "${var.name}-vpc-flow-logs"
  acl    = "private"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${var.s3_log_bucket_name}"
    target_prefix = "${var.name}-vpc-flow-logs/"
  }

  tags = "${merge(
    map(
      "Name", "${var.name}--vpc-flow-logs",
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
