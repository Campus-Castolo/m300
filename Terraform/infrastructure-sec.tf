# ECS WordPress Fargate Security Group
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

# RDS MySQL Security Group
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

  # Prevent premature destroy until RDS is gone
  # lifecycle {
  #   prevent_destroy = true
  # }

  # Make SG deletion wait until both DBs are destroyed
  # depends_on = [
  #   aws_db_instance.wordpress_db_1,
  #   aws_db_instance.wordpress_db_2
  # ]
}

# Allow ECS → RDS (MySQL 3306)
resource "aws_security_group_rule" "ecs_to_db" {
  type                     = "ingress"
  from_port               = 3306
  to_port                 = 3306
  protocol                = "tcp"
  source_security_group_id = aws_security_group.security_group-ecs-wordpress.id
  security_group_id        = aws_security_group.security_group-db.id
  description              = "Allow MySQL from ECS to RDS"
}

# Allow RDS → RDS Replication (DB1 to DB2)
resource "aws_security_group_rule" "db1_to_db2_replication" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.security_group-db.id
  security_group_id        = aws_security_group.security_group-db.id
  description              = "Allow RDS DB1 to replicate to DB2"
}

# ALB Security Group
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
