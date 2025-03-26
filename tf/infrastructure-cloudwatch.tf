# CloudWatch Log Group for ECS Task Logging
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/wordpress"
  retention_in_days = 7

  tags = {
    Name = "ECS WordPress Logs"
  }
}
