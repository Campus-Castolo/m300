variable "aws_region" {
  type        = string
  description = "AWS region to deploy to"
}

variable "aws_access_key" {
  type        = string
  description = "AWS access key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret key"
}

variable "aws_session_token" {
  type        = string
  description = "AWS session token (for temporary credentials)"
}

variable "db_password" {
  type        = string
  description = "Password for the RDS database"
  sensitive   = true
}

variable "db_username" {
    type        = string
    description = "Username for the RDS database"
}