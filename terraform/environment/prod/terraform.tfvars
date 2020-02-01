# VPC
name         = "go-rest-api-prod"
environment  = "prod"
service_name = "go-rest-api"
cidr_block   = "10.0.0.0/16"

# Network
subnets_public1  = ["10.0.0.0/24"]
subnets_public2  = ["10.0.1.0/24"]
subnets_private1 = ["10.0.2.0/24"]
subnets_private2 = ["10.0.3.0/24"]

# S3
s3_log_bucket_name = "go-rest-api-s3-log"

# ALB
acm_certificate_id = "97112dba-4948-4ff9-9ba2-c3b9e05476dc"

# ROUTE53
fqdn = "go-rest-api.stevenquan.co.uk"

# ECS
app_port      = "3000"
ecs_cpu       = "256"
ecs_memory    = "512"
desired_count = "4"

# MONGODB
mongo_project_name                = "go-api-rest-demo"
mongo_username                    = "go-api-demo"
mongo_replication_factor          = "3"
mongo_db_major_version            = "4.2"
mongo_disk_size_gb                = "100"
mongo_provider_disk_iops          = "300"
mongo_provider_instance_size_name = "M10"
mongo_provider_region_name        = "EU_WEST_1"
