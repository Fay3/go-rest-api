# ENV VARS
variable "aws_account_id" {
  description = "(Required) The AWS ACCOUNT ID"
}

variable "route53_hosted_zone" {
  description = "(Required) The Route53 Hosted Zone"
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

# S3
variable "s3_log_bucket_name" {
  description = "(Required) The name of the s3 log bucket"
}

# ALB
variable "acm_certificate_id" {
  description = "(Required) The ACM SSL certificate ID"
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

#MONGODB
variable "mongo_org_id" {
  description = "(Required) The mongodb atlas org ID"
}
variable "mongo_project_name" {
  description = "(Required) The project name for the mongo cluster"
}

variable "mongo_username" {
  description = "(Required) The mongodb username"
}

variable "mongo_password" {
  description = "(Required) The mongodb password"
}

variable "mongo_replication_factor" {
  description = "(Required) The desired count of mongodb instances"
}

variable "mongo_db_major_version" {
  description = "(Required) The version of mongodb"
}

variable "mongo_disk_size_gb" {
  description = "(Required) The disk size for mongodb cluster"
}

variable "mongo_provider_disk_iops" {
  description = "(Required) The disk iops for mongodb clsuter"
}

variable "mongo_provider_instance_size_name" {
  description = "(Required) The mongodb instance size"
}

variable "mongo_provider_region_name" {
  description = "(Required) The region to provision mongodb cluster"
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
