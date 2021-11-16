#================================#
# CREATES ECS CLUSTER ON FARGATE
#================================#
resource "aws_ecs_cluster" "foo" {
  name = var.cluster_name
}

resource "aws_security_group" "allow_all_a" {
  name        = "sgfargate"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.foo.id

  ingress {
    protocol    = "6"
    from_port   = 18332
    to_port     = 18332
    cidr_blocks = [aws_vpc.foo.cidr_block]
  }
}

resource "aws_ecs_service" "bar" {
  name             = var.service_name
  cluster          = aws_ecs_cluster.foo.id
  task_definition  = aws_ecs_task_definition.btc-task.arn
  desired_count    = var.service_count
  launch_type      = "FARGATE"
  platform_version = "1.4.0" //not specfying this version explictly will not currently work for mounting EFS to Fargate

  network_configuration {
    security_groups  = [aws_security_group.allow_all_a.id]
    subnets          = [aws_subnet.alpha.id]
    assign_public_ip = false
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = var.cloudwatch_group
}
