resource "mongodbatlas_project" "mongodb_project" {
  name   = "${var.mongo_project_name}"
  org_id = "${var.mongo_org_id}"
}

resource "mongodbatlas_database_user" "test" {
  username      = "${var.mongo_username}"
  password      = "${var.mongo_password}"
  project_id    = "${mongodbatlas_project.mongodb_project.id}"
  database_name = "admin"

  roles {
    role_name     = "readWriteAnyDatabase"
    database_name = "admin"
  }
}
resource "mongodbatlas_cluster" "mongo-cluster" {
  project_id = "${mongodbatlas_project.mongodb_project.id}"
  name       = "${var.name}"

  replication_factor           = "${var.mongo_replication_factor}"
  auto_scaling_disk_gb_enabled = true
  mongo_db_major_version       = "${var.mongo_db_major_version}"

  //Provider Settings "block"
  provider_name               = "AWS"
  disk_size_gb                = "${var.mongo_disk_size_gb}"
  provider_disk_iops          = "${var.mongo_provider_disk_iops}"
  provider_volume_type        = "STANDARD"
  provider_encrypt_ebs_volume = true
  provider_instance_size_name = "${var.mongo_provider_instance_size_name}"
  provider_region_name        = "${var.mongo_provider_region_name}"
}

resource "mongodbatlas_project_ip_whitelist" "app_whitelist" {
  project_id = "${mongodbatlas_project.mongodb_project.id}"

  whitelist {
    ip_address = "${aws_eip.natgw_eip_pub1.public_ip}"
    comment    = "Fargate NatGateway 1"
  }
  whitelist {
    ip_address = "${aws_eip.natgw_eip_pub2.public_ip}"
    comment    = "Fargate NatGateway 2"
  }
}
