variable "aws_account_id" {
  description = "(Required) The AWS ACCOUNT ID"
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
