resource "aws_s3_bucket" "bucket" {
  bucket = "${var.s3_bucket_name}"
  acl    = "private"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${var.s3_log_bucket_name}"
    target_prefix = "${var.s3_bucket_name}/"
  }

  tags = "${merge(
    map(
      "Name", "${var.s3_bucket_name}",
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
  bucket = "${var.s3_log_bucket_name}"
  acl    = "log-delivery-write"

  tags = "${merge(
    map(
      "Name", "${var.s3_log_bucket_name}",
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
