variable "vpc_id" {
  description = "(Required) The id of the VPC the route table / subnets are created within"
}

variable "availability_zones" {
  type        = "list"
  description = "(Required) The list of availability zones to associate to the subnets (must match subnets list length)"
}

variable "subnet_type" {
  description = "(Required) Type of subnet for naming including its number i.e 'private1', 'public1', 'data1'"
}

variable "subnet_count" {
  description = "(Required) The number of the subnet for naming including its number i.e 'private1', 'private2', 'data1'"
}

variable "subnets" {
  type        = "list"
  description = "(Required) The list of subnets to create against the route table"
}

variable "public" {
  description = "If set to true, puts in public acl"
}

variable "private" {
  description = "If set to true, puts in private acl"
}

# Tags

variable "name" {
  description = "(Required) The name of the application that the resource belongs to - used for tagging."
}

variable "environment" {
  description = "(Required) The name of the environment that the resource belongs to - used for tagging."
}

variable "service_name" {
  description = "(Required) The name of the service that the resource belongs to - used for tagging."
}

variable "network" {
  description = "(Required) The name of the network type that the resource belongs to - used for tagging."
}
