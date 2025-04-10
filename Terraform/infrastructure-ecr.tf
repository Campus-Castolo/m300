resource "aws_ecr_repository" "m300" {
  name                 = "m300"
  image_tag_mutability = "MUTABLE" # Allows overwriting tags like "latest"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "m300"
    Environment = "dev"
  }
}

# Lifecycle Policy: Keep 3 most recent tagged images, delete untagged and old ones
resource "aws_ecr_lifecycle_policy" "m300_policy" {
  repository = aws_ecr_repository.m300.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images"
        selection = {
          tagStatus     = "untagged"
          countType     = "imageCountMoreThan"
          countNumber   = 1
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep only 3 recent tagged images"
        selection = {
          tagStatus     = "tagged"
          countType     = "imageCountMoreThan"
          countNumber   = 3
          tagPrefixList = ["latest"]
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
