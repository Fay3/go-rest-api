# VPC
output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

# Internet Gateway
output "vpc_igw_id" {
  value = "${aws_internet_gateway.igw.id}"
}

output "pub1_subnet_ids" {
  value = "${module.Public1.subnet_ids}"
}

output "pub2_subnet_ids" {
  value = "${module.Public2.subnet_ids}"
}

output "priv1_subnet_ids" {
  value = "${module.Private1.subnet_ids}"
}

output "priv2_subnet_ids" {
  value = "${module.Private2.subnet_ids}"
}
output "priv1_ngw_ip" {
  value = "${aws_eip.natgw_eip_pub1.public_ip}"
}
output "priv2_ngw_ip" {
  value = "${aws_eip.natgw_eip_pub2.public_ip}"
}

output "mongo_cluster_id" {
  value = "${mongodbatlas_cluster.mongo-cluster.cluster_id}"
}

output "mongo_srv_address" {
  value = "${mongodbatlas_cluster.mongo-cluster.srv_address}"
}
