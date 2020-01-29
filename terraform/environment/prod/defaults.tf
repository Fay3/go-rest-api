locals {
  default_tags = {
    BuiltBy = "Terraform"
  }
}

variable "enable_dns_support" {
  description = "(Optional) A boolean flag to enable/disable DNS support in the VPC. Defaults to true."
  default     = true
}

variable "enable_dns_hostnames" {
  description = "(Optional) A boolean flag to enable/disable DNS hostnames in the VPC. Defaults to true."
  default     = true
}
variable "map_public_ip_on_launch" {
  description = "(Optional) Specify true to indicate that instances launched into the subnet should be assigned a public IP address."
  default     = false
}

variable "network_pub" {
  description = "(Required) The name of the network type that the resource belongs to - used for tagging."
  default     = "public"
}

variable "network_pri" {
  description = "(Required) The name of the network type that the resource belongs to - used for tagging."
  default     = "private"
}

variable "availability_zones_a" {
  type        = "list"
  description = "(Required) The list of availability zones to associate to the subnets (must match subnets list length)"
  default     = ["eu-west-1a"]
}

variable "availability_zones_b" {
  type        = "list"
  description = "(Required) The list of availability zones to associate to the subnets (must match subnets list length)"
  default     = ["eu-west-1b"]
}
