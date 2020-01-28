# VPC
output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

# Internet Gateway
output "vpc_igw_id" {
  value = "${aws_internet_gateway.igw.id}"
}
