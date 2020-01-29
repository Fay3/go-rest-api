# ALB Security group
# This is the group you need to edit if you want to restrict access to your application
resource "aws_security_group" "sg_alb" {
  name        = "ALBSecurityGroup-${var.name}"
  description = "Allows access to the ALB"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(
    map(
      "Name", "EIPNATGPublic1-${var.name}",
      "Environment", "${var.environment}",
      "ServiceName", "${var.service_name}",
    ),
    local.default_tags
  )}"

}

# Traffic to the ECS Cluster should only come from the ALB
resource "aws_security_group" "sg_ecs_tasks" {
  name        = "ECSSecurityGroup-${var.name}"
  description = "Allows inbound access from the ALB only"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    protocol        = "tcp"
    from_port       = "3000"
    to_port         = "3000"
    security_groups = ["${aws_security_group.sg_alb.id}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(
    map(
      "Name", "EIPNATGPublic1-${var.name}",
      "Environment", "${var.environment}",
      "ServiceName", "${var.service_name}",
    ),
    local.default_tags
  )}"

}
