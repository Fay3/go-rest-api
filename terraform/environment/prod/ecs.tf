locals {
  mongo_host = replace("${mongodbatlas_cluster.mongo-cluster.srv_address}", "mongodb+srv://", "")
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name               = "ECSCLUSTER-${var.name}"
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  tags = "${merge(
    map(
      "Name", "ECSCLUSTER-${var.name}",
      "Environment", "${var.environment}",
      "ServiceName", "${var.service_name}",
    ),
    local.default_tags
  )}"

}

resource "aws_ecs_task_definition" "task_def" {
  family                   = "${var.name}-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.ecs_cpu}"
  memory                   = "${var.ecs_memory}"
  execution_role_arn       = "${aws_iam_role.ecs_task_role.arn}"

  container_definitions = <<DEFINITION
[
    {
        "name": "go-rest-api-prod",
        "image": "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.ecr_repo}:${var.docker_tag}",
        "command": [
          "/bin/api-app"
        ],
        "portMappings": [
            {
                "containerPort": ${var.app_port},
                "hostPort": ${var.app_port}
            }
        ],
        "memory": ${var.ecs_memory},
        "cpu": ${var.ecs_cpu},
        "networkMode": "awsvpc",
        "environment": [
            {
                "name": "DB_URI",
                "value": "mongodb+srv://${var.mongo_username}:${var.mongo_password}@${local.mongo_host}/test?w=majority"
            }
        ],
        "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "${var.name}-log-group",
            "awslogs-region": "eu-west-1",
            "awslogs-stream-prefix": "ecs"
            }
        }
    }
]
DEFINITION

  tags = "${merge(
    map(
      "Name", "ECSTASKDEF-${var.name}",
      "Environment", "${var.environment}",
      "ServiceName", "${var.service_name}",
    ),
    local.default_tags
  )}"
}

resource "aws_ecs_service" "main" {
  name            = "ECSSERVICE-${var.name}"
  cluster         = "${aws_ecs_cluster.ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.task_def.arn}"
  desired_count   = "${var.desired_count}"
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 50
  }

  count = length(module.Private1.subnet_ids)

  network_configuration {
    security_groups = ["${aws_security_group.sg_ecs_tasks.id}"]
    subnets         = ["${module.Private1.subnet_ids.0[count.index]}", "${module.Private2.subnet_ids.0[count.index]}"]
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.alb_tg.id}"
    container_name   = "${var.name}"
    container_port   = "${var.app_port}"
  }

  lifecycle {
    ignore_changes = ["desired_count"]
  }

  depends_on = [
    "aws_alb_listener.alb_ln",
  ]
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ECSTASKROLE-${var.name}"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ecs_task_policy" {
  name = "ECSTASKEXEC-${var.name}"
  role = "${aws_iam_role.ecs_task_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "*"
      }
    ]
}
EOF
}
