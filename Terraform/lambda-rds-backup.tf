# -----------------------------------------------------------------------------
# 1. IAM Role for Lambda
# -----------------------------------------------------------------------------
resource "aws_iam_role" "lambda_rds_snapshot" {
  name = "lambda-rds-snapshot-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_rds_snapshot_policy" {
  name = "lambda-rds-snapshot-policy"
  role = aws_iam_role.lambda_rds_snapshot.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "rds:CreateDBSnapshot",
          "rds:ListTagsForResource",
          "rds:AddTagsToResource",
          "rds:DescribeDBInstances"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
        Resource = "*"
      }
    ]
  })
}

# -----------------------------------------------------------------------------
# 2. Lambda Function to create timestamped RDS snapshot
# -----------------------------------------------------------------------------
data "archive_file" "lambda_rds_snapshot_zip" {
  type        = "zip"
  source_dir = "./lambda"
  output_path = "./lambda.zip"
}

resource "aws_lambda_function" "rds_snapshot" {
  function_name = "rds-create-snapshot"
  role          = aws_iam_role.lambda_rds_snapshot.arn
  handler       = "rds_snapshot.lambda_handler"
  runtime       = "python3.11"
  filename      = data.archive_file.lambda_rds_snapshot_zip.output_path
  timeout       = 30

  environment {
    variables = {
      RDS_INSTANCE_IDENTIFIER = var.db_instance_identifier
    }
  }
}

# -----------------------------------------------------------------------------
# 3. EventBridge Rule to schedule daily snapshot
# -----------------------------------------------------------------------------
resource "aws_cloudwatch_event_rule" "daily_rds_snapshot" {
  name                = "daily-rds-snapshot"
  schedule_expression = "cron(0 2 * * ? *)" # Every day at 02:00 UTC
}

resource "aws_cloudwatch_event_target" "lambda_rds_snapshot" {
  rule      = aws_cloudwatch_event_rule.daily_rds_snapshot.name
  target_id = "InvokeLambda"
  arn       = aws_lambda_function.rds_snapshot.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rds_snapshot.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_rds_snapshot.arn
}

# -----------------------------------------------------------------------------
# 4. Variables
# -----------------------------------------------------------------------------
variable "db_instance_identifier" {
  type        = string
  description = "The RDS DB instance identifier to snapshot."
}
