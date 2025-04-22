# ------------------------
# ALB Security Group
# ------------------------
resource "aws_security_group" "security_group-alb" {
  name        = "security-group-alb"
  description = "Allow public HTTP to ALB"
  vpc_id      = aws_vpc.m300_vpc.id

  ingress {
    description = "Public access to ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound from ALB"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB SG"
  }
}

# ------------------------
# ECS WordPress Fargate Security Group
# ------------------------
resource "aws_security_group" "security_group-ecs-wordpress" {
  name        = "security-group-ecs-wordpress"
  description = "Allow HTTP traffic to ECS WordPress containers"
  vpc_id      = aws_vpc.m300_vpc.id

  ingress {
    description = "Allow public HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ECS WordPress SG"
  }
}

# ------------------------
# RDS MySQL Security Group
# ------------------------
resource "aws_security_group" "security_group-db" {
  name        = "security-group-db"
  description = "Allow internal access to RDS from ECS and replication"
  vpc_id      = aws_vpc.m300_vpc.id

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS DB SG"
  }
}

# ------------------------
# Allow ECS → RDS (MySQL 3306)
# ------------------------
resource "aws_security_group_rule" "ecs_to_db" {
  type                     = "ingress"
  from_port               = 3306
  to_port                 = 3306
  protocol                = "tcp"
  source_security_group_id = aws_security_group.security_group-ecs-wordpress.id
  security_group_id        = aws_security_group.security_group-db.id
  description              = "Allow MySQL from ECS to RDS"
}

# ------------------------
# Allow RDS → RDS Replication (DB1 to DB2)
# ------------------------
resource "aws_security_group_rule" "db1_to_db2_replication" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.security_group-db.id
  security_group_id        = aws_security_group.security_group-db.id
  description              = "Allow RDS DB1 to replicate to DB2"
}

# ------------------------
# VPC Flow Logs and IAM Role for Observability
# ------------------------
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/flow-logs"
  retention_in_days = 14
}

resource "aws_iam_role" "vpc_flow_logs" {
  name = "vpc-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      },
      Effect = "Allow",
      Sid    = ""
    }]
  })
}

resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  name = "vpc-flow-logs-policy"
  role = aws_iam_role.vpc_flow_logs.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_flow_log" "vpc" {
  vpc_id              = aws_vpc.m300_vpc.id
  traffic_type        = "ALL"
  log_destination     = aws_cloudwatch_log_group.vpc_flow_logs.arn
  log_destination_type = "cloud-watch-logs"
  iam_role_arn        = aws_iam_role.vpc_flow_logs.arn
}
