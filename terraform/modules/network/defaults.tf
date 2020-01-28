variable "map_public_ip_on_launch" {
  description = "(Optional) Specify true to indicate that instances launched into the subnet should be assigned a public IP address."
  default     = false
}

# Tags

locals {
  default_tags = {
    ServiceOwner = "thomas.gardham-pallister@news.co.uk"
    BuiltBy      = "terraform"
  }
}

variable "default_tags" {
  type        = "map"
  description = "(Optional) A map of additional tags to associate with the resource."
  default     = {}
}