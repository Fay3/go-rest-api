resource "aws_s3_bucket" "bucket" {
  bucket = "${var.name}-terraform-state"
  acl    = "private"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${var.name}-s3-log"
    target_prefix = "${var.name}-terraform-state/"
  }

  tags = "${merge(
    map(
      "Name", "${var.name}-terraform-state",
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

resource "aws_s3_bucket" "log-bucket" {
  bucket = "${var.name}-s3-log"
  acl    = "log-delivery-write"

  tags = "${merge(
    map(
      "Name", "${var.name}-s3-log",
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
