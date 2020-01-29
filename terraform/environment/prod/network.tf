module "Public1" {
  source = "../../modules/network/"

  public  = 1
  private = 0

  name               = "${var.name}"
  subnet_type        = "PubSubnet1"
  subnet_count       = "1"
  subnets            = "${var.subnets_public1}"
  environment        = "${var.environment}"
  network            = "${var.network_pub}"
  service_name       = "${var.service_name}"
  availability_zones = "${var.availability_zones_a}"
  vpc_id             = "${aws_vpc.vpc.id}"
}

module "Public2" {
  source = "../../modules/network/"

  public  = 1
  private = 0

  name               = "${var.name}"
  subnet_type        = "PubSubnet2"
  subnet_count       = "2"
  subnets            = "${var.subnets_public2}"
  environment        = "${var.environment}"
  network            = "${var.network_pub}"
  service_name       = "${var.service_name}"
  availability_zones = "${var.availability_zones_b}"
  vpc_id             = "${aws_vpc.vpc.id}"
}

module "Private1" {
  source = "../../modules/network/"

  public  = 0
  private = 1

  name               = "${var.name}"
  subnet_type        = "PriSubnet1"
  subnet_count       = "1"
  subnets            = "${var.subnets_private1}"
  environment        = "${var.environment}"
  network            = "${var.network_pri}"
  service_name       = "${var.service_name}"
  availability_zones = "${var.availability_zones_a}"
  vpc_id             = "${aws_vpc.vpc.id}"
}

module "Private2" {
  source = "../../modules/network/"

  public  = 0
  private = 1

  name               = "${var.name}"
  subnet_type        = "PriSubnet2"
  subnet_count       = "2"
  subnets            = "${var.subnets_private2}"
  environment        = "${var.environment}"
  network            = "${var.network_pri}"
  service_name       = "${var.service_name}"
  availability_zones = "${var.availability_zones_b}"
  vpc_id             = "${aws_vpc.vpc.id}"
}

# Route public1 subnet to IGW
resource "aws_route" "route_public1_igw" {
  route_table_id         = "${module.Public1.route_table_pub_id.0}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

# Route public2 subnet to IGW
resource "aws_route" "route_public2_igw" {
  route_table_id         = "${module.Public2.route_table_pub_id.0}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

# Route private1 subnet to IGW
resource "aws_route" "route_private1_ngw" {
  route_table_id         = "${module.Private1.route_table_pri_id.0}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.gw1.0.id}"
}

# Route private2 subnet to IGW
resource "aws_route" "route_private2_ngw" {
  route_table_id         = "${module.Private2.route_table_pri_id.0}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.gw2.0.id}"
}

resource "aws_eip" "natgw_eip_pub1" {
  vpc = true

  tags = "${merge(
    map(
      "Name", "EIPNATGPublic1-${var.name}",
      "Environment", "${var.environment}",
      "ServiceName", "${var.service_name}",
    ),
    local.default_tags
  )}"
}

resource "aws_nat_gateway" "gw1" {
  count         = length(module.Public1.subnet_ids)
  allocation_id = "${aws_eip.natgw_eip_pub1.id}"
  subnet_id     = "${module.Public1.subnet_ids.0[count.index]}"

  tags = "${merge(
    map(
      "Name", "NATGPublic1-${var.name}",
      "Environment", "${var.environment}",
      "ServiceName", "${var.service_name}",
    ),
    local.default_tags
  )}"
}

resource "aws_eip" "natgw_eip_pub2" {
  vpc = true

  tags = "${merge(
    map(
      "Name", "EIPNATGPublic2-${var.name}",
      "Environment", "${var.environment}",
      "ServiceName", "${var.service_name}",
    ),
    local.default_tags
  )}"
}

resource "aws_nat_gateway" "gw2" {
  count         = length(module.Public2.subnet_ids)
  allocation_id = "${aws_eip.natgw_eip_pub2.id}"
  subnet_id     = "${module.Public2.subnet_ids.0[count.index]}"

  tags = "${merge(
    map(
      "Name", "NATGPublic2-${var.name}",
      "Environment", "${var.environment}",
      "ServiceName", "${var.service_name}",
    ),
    local.default_tags
  )}"
}
