locals {
  alb_arn_suffix = element(split("/", aws_lb.ecs_alb.arn), 1)
}

# CloudWatch Log Group for ECS Task Logging
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/wordpress"
  retention_in_days = 7

  tags = {
    Name = "ECS WordPress Logs"
  }
}

# SNS Topic for Alarm Notifications
resource "aws_sns_topic" "alarm_notifications" {
  name = "cloudwatch-alarm-notifications"
}

# Email subscription
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alarm_notifications.arn
  protocol  = "email"
  endpoint  = "rayanbopp@gmail.com"
}

# SMS subscription
resource "aws_sns_topic_subscription" "sms" {
  topic_arn = aws_sns_topic.alarm_notifications.arn
  protocol  = "sms"
  endpoint  = "+41786957297"
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "WordPressMonitoringDashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        "type": "metric",
        "x": 0, "y": 0, "width": 12, "height": 6,
        "properties": {
          "metrics": [
            [ "AWS/ECS", "CPUUtilization", "ClusterName", aws_ecs_cluster.wordpress_cluster.name, "ServiceName", aws_ecs_service.wordpress_service.name ],
            [ ".", "MemoryUtilization", ".", ".", ".", "." ]
          ],
          "title": "ECS CPU & Memory",
          "region": var.aws_region,
          "period": 300,
          "stat": "Average"
        }
      },
      {
        "type": "metric",
        "x": 12, "y": 0, "width": 12, "height": 6,
        "properties": {
          "metrics": [
            [ "AWS/ApplicationELB", "RequestCount", "LoadBalancer", local.alb_arn_suffix ],
            [ ".", "HTTPCode_Target_5XX_Count", ".", "." ]
          ],
          "title": "ALB Requests & Errors",
          "region": var.aws_region,
          "period": 300,
          "stat": "Sum"
        }
      },
      {
        "type": "metric",
        "x": 0, "y": 6, "width": 12, "height": 6,
        "properties": {
          "metrics": [
            [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", aws_db_instance.wordpress_db_1.id ],
            [ ".", "FreeStorageSpace", ".", "." ]
          ],
          "title": "RDS CPU & Free Storage",
          "region": var.aws_region,
          "period": 300,
          "stat": "Average"
        }
      }
    ]
  })
}

# ECS Alarm
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
  alarm_actions       = [aws_sns_topic.alarm_notifications.arn]
  dimensions = {
    ClusterName = aws_ecs_cluster.wordpress_cluster.name
    ServiceName = aws_ecs_service.wordpress_service.name
  }
}

# ALB Alarm
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
  alarm_actions       = [aws_sns_topic.alarm_notifications.arn]
  dimensions = {
    LoadBalancer = local.alb_arn_suffix
  }
}

# RDS Alarm
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
  alarm_actions       = [aws_sns_topic.alarm_notifications.arn]
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.wordpress_db_1.id
  }
}

# ✅ Demo Alarm – always triggers for testing
resource "aws_cloudwatch_metric_alarm" "demo_trigger_alarm" {
  alarm_name          = "DemoTriggerAlways"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 0.1
  alarm_description   = "Demo alarm that always triggers"
  alarm_actions       = [aws_sns_topic.alarm_notifications.arn]
  dimensions = {
    ClusterName = aws_ecs_cluster.wordpress_cluster.name
    ServiceName = aws_ecs_service.wordpress_service.name
  }
}
