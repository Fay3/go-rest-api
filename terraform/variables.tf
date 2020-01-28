variable "s3_bucket_name" {
  description = "(Required) The name of the s3 bucket"
}

variable "s3_log_bucket_name" {
  description = "(Required) The name of the s3 log bucket"
}

variable "name" {
  description = "(Required) The name of the application that the resource belongs to - used for tagging."
}

variable "service_name" {
  description = "(Required) The name of the service_name being deployed"
}

variable "environment" {
  description = "(Required) The name of the environment being deployed to…"
}
