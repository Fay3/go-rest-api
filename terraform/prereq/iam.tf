resource "aws_iam_user" "ci_svc" {
  name = "ci-svc-user"

  tags = "${merge(
    map(
      "Name", "${var.name}-ci-svc-user",
      "Environment", "${var.environment}",
      "ServiceName", "${var.service_name}"
    ),
    local.default_tags
  )}"
}

resource "aws_iam_role" "ci_svc_assume_iam_role" {
  name        = "CIASSUMEROLE-${var.name}"
  description = "Role to be consmed by ci"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                 "AWS": "arn:aws:iam::${var.aws_account_id}:user/ci-svc-user"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

data "aws_iam_policy" "AmazonEC2ContainerRegistryPowerUser" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

data "aws_iam_policy" "AmazonECS_FullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

data "aws_iam_policy" "ElasticLoadBalancingFullAccess" {
  arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
}

data "aws_iam_policy" "CloudWatchLogsFullAccess" {
  arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_full" {
  role       = "${aws_iam_role.ci_svc_assume_iam_role.id}"
  policy_arn = "${data.aws_iam_policy.AmazonECS_FullAccess.arn}"
}

resource "aws_iam_role_policy_attachment" "ecr_push" {
  role       = "${aws_iam_role.ci_svc_assume_iam_role.id}"
  policy_arn = "${data.aws_iam_policy.AmazonEC2ContainerRegistryPowerUser.arn}"
}

resource "aws_iam_role_policy_attachment" "alb_access" {
  role       = "${aws_iam_role.ci_svc_assume_iam_role.id}"
  policy_arn = "${data.aws_iam_policy.ElasticLoadBalancingFullAccess.arn}"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_access" {
  role       = "${aws_iam_role.ci_svc_assume_iam_role.id}"
  policy_arn = "${data.aws_iam_policy.CloudWatchLogsFullAccess.arn}"
}

resource "aws_iam_role_policy" "s3_access" {
  name = "S3-ACCESS-POLICY-${var.name}"
  role = "${aws_iam_role.ci_svc_assume_iam_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
              "arn:aws:s3:::${var.name}-*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "terraform_access" {
  name = "TERRAFORM-ACCESS-POLICY-${var.name}"
  role = "${aws_iam_role.ci_svc_assume_iam_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:CreatePolicy",
                "iam:DeletePolicy",
                "iam:PutRolePolicy",
                "iam:Get*",
                "iam:List*",
                "route53:*",
                "route53domains:*",
                "ec2:*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}
