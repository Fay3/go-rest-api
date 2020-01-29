# ENV VARS
variable "aws_account_id" {
  description = "(Required) The AWS ACCOUNT ID"
}

variable "route53_hosted_zone" {
  description = "(Required) The Route53 Hosted Zone"
}
variable "DB_URI" {
  description = "(Required) The mongodb uri connection string"
}

variable "mongodbatlas_public_key" {
  description = "(Required) The Public Key Used For Mongo Atlas API"
}
variable "mongodbatlas_private_key" {
  description = "(Required) The Public Key Used For Mongo Atlas API"
}

#VPC
variable "cidr_block" {
  description = "(Required) The CIDR block for the VPC"
}

# Network
variable "subnets_public1" {
  type        = "list"
  description = "(Required) The list of subnets to create against the route table"
}

variable "subnets_public2" {
  type        = "list"
  description = "(Required) The list of subnets to create against the route table"
}

variable "subnets_private1" {
  type        = "list"
  description = "(Required) The list of subnets to create against the route table"
}

variable "subnets_private2" {
  type        = "list"
  description = "(Required) The list of subnets to create against the route table"
}

# Tags
variable "name" {
  description = "(Required) The name of the application that the resource belongs to - used for tagging."
}

variable "environment" {
  description = "(Required) The name of the environment that the resource belongs to - used for tagging."
}

variable "service_name" {
  description = "(Required) The name of the project that the resource belongs to - used for tagging."
}

# S3
variable "s3_log_bucket_name" {
  description = "(Required) The name of the s3 log bucket"
}

# ECS

variable "app_port" {
  description = "(Required) The port for the docker app"
}

variable "ecs_cpu" {
  description = "(Required) The cpu for ecs task deffinition"
}

variable "ecs_memory" {
  description = "(Required) The memory for ecs task deffinition"
}

variable "desired_count" {
  description = "(Required) The desired count of containers"
}
