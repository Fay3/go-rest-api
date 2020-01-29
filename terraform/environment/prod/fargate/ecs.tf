resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ECSCLUSTER-${var.name}"
}

resource "aws_ecs_task_definition" "task_def" {
  family                   = "${var.name}-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = "${file("task-definitions/service.json")}"

}

resource "aws_ecs_service" "main" {
  name            = "ECSSERVICE-${var.name}"
  cluster         = "${aws_ecs_cluster.ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.task_def.arn}"
  desired_count   = "1"
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