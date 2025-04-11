# CloudWatch Log Group for ECS Task Logging
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/wordpress"
  retention_in_days = 7

  tags = {
    Name = "ECS WordPress Logs"
  }
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "WordPressMonitoringDashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        "type": "metric",
        "x": 0, "y": 0, "width": 12, "height": 6,
        "properties": {
          "metrics": [
            [ "AWS/ECS", "CPUUtilization", "ClusterName", "${var.ecs_cluster_name}", "ServiceName", "${var.ecs_service_name}" ],
            [ ".", "MemoryUtilization", ".", ".", ".", "." ]
          ],
          "title": "ECS CPU & Memory", "region": "${var.aws_region}", "period": 300, "stat": "Average"
        }
      },
      {
        "type": "metric",
        "x": 12, "y": 0, "width": 12, "height": 6,
        "properties": {
          "metrics": [
            [ "AWS/ApplicationELB", "RequestCount", "LoadBalancer", "${var.alb_arn_suffix}" ],
            [ ".", "HTTPCode_Target_5XX_Count", ".", "." ]
          ],
          "title": "ALB Requests & Errors", "region": "${var.aws_region}", "period": 300, "stat": "Sum"
        }
      },
      {
        "type": "metric",
        "x": 0, "y": 6, "width": 12, "height": 6,
        "properties": {
          "metrics": [
            [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "${var.db_instance_identifier}" ],
            [ ".", "FreeStorageSpace", ".", "." ]
          ],
          "title": "RDS CPU & Free Storage", "region": "${var.aws_region}", "period": 300, "stat": "Average"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "HighECSCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "High ECS CPU usage."
  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {
  alarm_name          = "ALB5xxErrors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Sum"
  threshold           = 5
  alarm_description   = "ALB 5xx error rate is too high."
  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_low_storage" {
  alarm_name          = "LowRDSStorage"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 5000000000
  alarm_description   = "RDS has less than 5GB of free storage."
  dimensions = {
    DBInstanceIdentifier = var.db_instance_identifier
  }
}
