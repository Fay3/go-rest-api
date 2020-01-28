# Route Table ID
output "route_table_pub_id" {
  value = "${aws_route_table.rtb_pub.*.id}"
}

output "route_table_pri_id" {
  value = "${aws_route_table.rtb_pri.*.id}"
}

# NACL ID
output "network_acl_pub_id" {
  value = "${aws_network_acl.acl_pub.*.id}"
}

output "network_acl_pri_id" {
  value = "${aws_network_acl.acl_pri.*.id}"
}

# Subnet IDs
output "subnet_ids" {
  value = ["${aws_subnet.subnet.*.id}"]
}
