# ECS Cluster
resource "aws_ecs_cluster" "wordpress_cluster" {
  name = "m300-wordpress-cluster"
}

# ECS Task Definition for Fargate
resource "aws_ecs_task_definition" "wordpress_task" {
  family                   = "wordpress-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = "arn:aws:iam::880731812020:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  task_role_arn            = "arn:aws:iam::880731812020:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"

  container_definitions = jsonencode([
    {
      name      = "wordpress"
      image     = "${aws_ecr_repository.m300.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ],
      environment = [
        {
          name  = "WORDPRESS_DB_HOST"
          value = aws_db_instance.wordpress_db_1.address
        },
        {
          name  = "WORDPRESS_DB_USER"
          value = "admin"
        },
        {
          name  = "WORDPRESS_DB_PASSWORD"
          value = var.db_password
        },
        {
          name  = "WORDPRESS_DB_NAME"
          value = "wordpressdb1"
        }
      ],
      log_configuration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/wordpress"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

# ECS Service for WordPress (Fargate)
resource "aws_ecs_service" "wordpress_service" {
  name            = "wordpress-service"
  cluster         = aws_ecs_cluster.wordpress_cluster.id
  task_definition = aws_ecs_task_definition.wordpress_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  health_check_grace_period_seconds = 60

  network_configuration {
    subnets         = [aws_subnet.public_1.id, aws_subnet.public_2.id]
    security_groups = [aws_security_group.security_group-ecs-wordpress.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "wordpress"
    container_port   = 80
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  depends_on = [
    aws_lb_listener.ecs_listener
  ]
}
