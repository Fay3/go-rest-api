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

