provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token      = var.aws_session_token
}

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_session_token" {}

# ECS Cluster
resource "aws_ecs_cluster" "wp_project" {
  name = "wp-project"
}

# Security Group for ECS tasks
resource "aws_security_group" "ecs_sg" {
  vpc_id = "#"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "wp_task" {
  family                   = "wp-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = "arn:aws:iam::880731812020:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  task_role_arn            = "arn:aws:iam::880731812020:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"

  container_definitions = jsonencode([
    {
      name      = "wordpress"
      image     = "wordpress:latest"
      cpu       = 512
      memory    = 1024
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      environment = []
      mountPoints = [
        {
          sourceVolume  = "efs_volume"
          containerPath = "/var/www/html"
        }
      ]
    }
  ])
  volume {
    name = "efs_volume"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.wp_efs.id
    }
  }
}

# ECS Service
resource "aws_ecs_service" "wp_service" {
  name            = "wp-service"
  cluster         = aws_ecs_cluster.wp_project.id
  task_definition = aws_ecs_task_definition.wp_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets         = ["subnet-0292f0861c73e93d1", "subnet-0b7558d7d042979d9"]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}

# RDS MySQL Primary Instance with Backups Enabled
resource "aws_db_instance" "wp_db_primary" {
  allocated_storage    = 20
  engine              = "mysql"
  instance_class      = "db.t3.micro"
  db_name             = "wordpress_db"
  username           = "admin"
  password           = "password123"
  parameter_group_name = "default.mysql8.0"
  backup_retention_period = 7  # Ensure backups are enabled
  backup_window            = "03:00-04:00"
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  multi_az = false
  db_subnet_group_name = aws_db_subnet_group.wp_db_subnet_group.name
}

# RDS MySQL Replica (Depends on Primary RDS Instance Backup)
resource "aws_db_instance" "wp_db_replica" {
  replicate_source_db = aws_db_instance.wp_db_primary.identifier
  instance_class      = "db.t3.micro"
  skip_final_snapshot = true
  depends_on = [aws_db_instance.wp_db_primary] # Ensure primary is ready
}

# RDS Security Group
resource "aws_security_group" "rds_sg" {
  vpc_id = "vpc-052b4d300fe8d6871"
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "wp_db_subnet_group" {
  name       = "wp-db-subnet-group"
  subnet_ids = ["subnet-0892c0399f2a48a66", "subnet-0316bdc48fefa3b87"]
}

# EFS for Persistent Storage
resource "aws_efs_file_system" "wp_efs" {
  creation_token = "wp-efs"
}

resource "aws_efs_mount_target" "wp_efs_mount_1" {
  file_system_id  = aws_efs_file_system.wp_efs.id
  subnet_id       = "subnet-0892c0399f2a48a66"
  security_groups = [aws_security_group.ecs_sg.id]
}

resource "aws_efs_mount_target" "wp_efs_mount_2" {
  file_system_id  = aws_efs_file_system.wp_efs.id
  subnet_id       = "subnet-0316bdc48fefa3b87"
  security_groups = [aws_security_group.ecs_sg.id]
}
