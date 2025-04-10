# IAM Policy for EC2 Network Interface Permissions
resource "aws_iam_policy" "ec2_network_interface_management" {
  name        = "EC2NetworkInterfaceManagementPolicy"
  description = "Allows managing EC2 network interfaces (for RDS ENI detachments)"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:DescribeNetworkInterfaces",
          "ec2:DetachNetworkInterface",
          "ec2:DeleteNetworkInterface"
        ],
        Resource = "*"
      }
    ]
  })
}

# Attach the policy to a specific IAM user (replace with your user name)
resource "aws_iam_user_policy_attachment" "attach_policy_to_user" {
  user       = "rayan"
  policy_arn = aws_iam_policy.ec2_network_interface_management.arn
}
