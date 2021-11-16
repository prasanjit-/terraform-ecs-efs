#================================#
# TASK DEFINITION
#================================#
data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_task_definition" "btc-task" {
  family                   = "btc-on-ecs-task-fargate"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = "${data.aws_iam_role.ecs_task_execution_role.arn}"
  container_definitions = jsonencode([
    {
      name      = "bitcoin"
      image     = "servergurus/bitcoin:0.21.0"
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = 8332
          hostPort      = 8332
        },
        {
          containerPort = 8333
          hostPort      = 8333
        },
        {
          containerPort = 18332
          hostPort      = 18332
        },
        {
          containerPort = 18333
          hostPort      = 18333
        },
        {
          containerPort = 18444
          hostPort      = 18444
        }
      ]
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "btcmonitoring",
          "awslogs-region" : "us-east-1",
          "awslogs-stream-prefix" : "ecs"
        }
      }
    }
  ])

  volume {
    name      = "efs-btc"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.foo.id
      root_directory = "/data"
    }
  }
}
