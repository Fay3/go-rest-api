#VPC
name         = "go-rest-api-prod"
environment  = "prod"
service_name = "go-rest-api"
cidr_block   = "10.0.0.0/16"

#Network
subnets_public1  = ["10.0.0.0/24"]
subnets_public2  = ["10.0.1.0/24"]
subnets_private1 = ["10.0.2.0/24"]
subnets_private2 = ["10.0.3.0/24"]
