# IAM User for developer read-only access
resource "aws_iam_user" "dev_view" {
  name = "bedrock-dev-view"

  tags = {
    Name = "bedrock-dev-view"
  }
}

# Console login profile
resource "aws_iam_user_login_profile" "dev_view" {
  user                    = aws_iam_user.dev_view.name
  password_reset_required = false
}

# Access key for CLI access
resource "aws_iam_access_key" "dev_view" {
  user = aws_iam_user.dev_view.name
}

# Attach ReadOnlyAccess policy
resource "aws_iam_user_policy_attachment" "read_only" {
  user       = aws_iam_user.dev_view.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# S3 PutObject policy for assets bucket
resource "aws_iam_policy" "s3_put" {
  name = "${var.project_name}-dev-s3-put-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:PutObject"]
      Resource = "${var.assets_bucket_arn}/*"
    }]
  })

  tags = {
    Name = "${var.project_name}-dev-s3-put-policy"
  }
}

resource "aws_iam_user_policy_attachment" "s3_put" {
  user       = aws_iam_user.dev_view.name
  policy_arn = aws_iam_policy.s3_put.arn
}
