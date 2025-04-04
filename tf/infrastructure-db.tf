# Create a subnet group using the two private subnets
resource "aws_db_subnet_group" "wordpress_db_subnet_group" {
  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  tags = {
    Name = "wordpress-db-subnet-group"
  }
}

# First DB instance in private_1
resource "aws_db_instance" "wordpress_db_1" {
  identifier              = "wordpress-db-${substr(replace(aws_subnet.private_1.id, "-", ""), 0, 8)}-${var.aws_region}"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.wordpress_db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.security_group-db.id]
  availability_zone       = aws_subnet.private_1.availability_zone
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false

  tags = {
    Name = "wordpress-db-1-${var.aws_region}"
  }
}

# Second DB instance in private_2
resource "aws_db_instance" "wordpress_db_2" {
  identifier              = "wordpress-db-${substr(replace(aws_subnet.private_2.id, "-", ""), 0, 8)}-${var.aws_region}"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.wordpress_db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.security_group-db.id]
  availability_zone       = aws_subnet.private_2.availability_zone
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false

  tags = {
    Name = "wordpress-db-2-${var.aws_region}"
  }
}
