provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token      = var.aws_session_token
}

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_session_token" {}

# ✅ VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# ✅ Subnets
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
}

# ✅ Internet Gateway & Routing
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

# ✅ NAT Gateway for Private Subnets
resource "aws_eip" "nat" {}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_rt.id
}

# ✅ Security Groups
resource "aws_security_group" "ecs_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }
}

# ✅ ECS Cluster
resource "aws_ecs_cluster" "wp_cluster" {
  name = "wp-cluster"
}

# ✅ Fix: Use Existing ECR Repository
data "aws_ecr_repository" "wp_repo" {
  name = "m300/m300"
}

# ✅ ECS Task Definition
resource "aws_ecs_task_definition" "wp_task" {
  family                   = "wp-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name  = "wordpress"
      image = "${data.aws_ecr_repository.wp_repo.repository_url}:latest"
      cpu   = 256
      memory = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

# ✅ ECS Service
resource "aws_ecs_service" "wp_service" {
  name            = "wp-service"
  cluster         = aws_ecs_cluster.wp_cluster.id
  task_definition = aws_ecs_task_definition.wp_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.public_1.id, aws_subnet.public_2.id]
    security_groups = [aws_security_group.ecs_sg.id]
  }
}

# ✅ RDS Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

# ✅ Primary RDS Instance
resource "aws_db_instance" "rds_primary" {
  allocated_storage       = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username              = "admin"
  password              = "password123"
  db_subnet_group_name  = aws_db_subnet_group.rds_subnet_group.name
  publicly_accessible    = false
  storage_encrypted      = true
  skip_final_snapshot    = true  # Fix IAM restriction on backups
}

# ✅ RDS Read Replica
resource "aws_db_instance" "rds_replica" {
  replicate_source_db = aws_db_instance.rds_primary.id
  instance_class      = "db.t3.micro"
  publicly_accessible = false
}

# ✅ CloudWatch Monitoring
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = "/ecs/wp-cluster"
}

# ✅ CloudWatch Alarm for RDS CPU Utilization
resource "aws_cloudwatch_metric_alarm" "rds_cpu_alarm" {
  alarm_name          = "rds-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name        = "CPUUtilization"
  namespace          = "AWS/RDS"
  period            = 60
  statistic         = "Average"
  threshold         = 80.0
  alarm_description = "This alarm monitors high CPU utilization on the MySQL RDS"
}

# ✅ Outputs
output "ecs_cluster_name" {
  value = aws_ecs_cluster.wp_cluster.name
}

output "rds_primary_endpoint" {
  value = aws_db_instance.rds_primary.endpoint
}

output "vpc_id" {
  value = aws_vpc.main_vpc.id
}
