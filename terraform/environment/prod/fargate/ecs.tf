resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ECSCLUSTER-${var.name}"
}

resource "aws_ecs_task_definition" "task_def" {
  family                   = "${var.name}-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "${aws_iam_role.ecs_task_role.arn}"

  container_definitions = <<DEFINITION
[
    {
        "name": "go-rest-api-prod",
        "image": "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/go-rest-api-demo:latest",
        "command": [
          "/bin/api-app"
        ],
        "portMappings": [
            {
                "containerPort": 300,
                "hostPort": 300
            }
        ],
        "memory": 512,
        "cpu": 256,
        "networkMode": "awsvpc",
        "environment": [
            {
                "name": "DB_URI",
                "value": "production"
            }
        ],
        "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "${var.name}-log-group}",
            "awslogs-region": "eu-west-1",
            "awslogs-stream-prefix": "ecs"
            }
        }
    }
]
DEFINITION
}

resource "aws_ecs_service" "main" {
  name            = "ECSSERVICE-${var.name}"
  cluster         = "${aws_ecs_cluster.ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.task_def.arn}"
  desired_count   = "2"
  launch_type     = "FARGATE"

  count = length(module.Private1.subnet_ids)

  network_configuration {
    security_groups = ["${aws_security_group.sg_ecs_tasks.id}"]
    subnets         = ["${module.Private1.subnet_ids.0[count.index]}", "${module.Private2.subnet_ids.0[count.index]}"]
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.alb_tg.id}"
    container_name   = "${var.name}"
    container_port   = "3000"
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
        "AWS": "arn:aws:iam::${var.aws_account_id}:root"
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
