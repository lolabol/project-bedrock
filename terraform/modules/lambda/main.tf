# IAM Role for Lambda
resource "aws_iam_role" "lambda" {
  name = "${var.project_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "${var.project_name}-lambda-role"
  }
}

# Lambda basic execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda.name
}

# Lambda S3 read policy
resource "aws_iam_policy" "lambda_s3" {
  name = "${var.project_name}-lambda-s3-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:ListBucket"
      ]
      Resource = [
        var.s3_bucket_arn,
        "${var.s3_bucket_arn}/*"
      ]
    }]
  })

  tags = {
    Name = "${var.project_name}-lambda-s3-policy"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_s3" {
  policy_arn = aws_iam_policy.lambda_s3.arn
  role       = aws_iam_role.lambda.name
}

# CloudWatch Log Group for Lambda
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/bedrock-asset-processor"
  retention_in_days = 7

  tags = {
    Name = "${var.project_name}-lambda-logs"
  }
}

# Lambda Function
resource "aws_lambda_function" "asset_processor" {
  filename         = "${path.module}/../../../lambda/asset_processor.zip"
  function_name    = "bedrock-asset-processor"
  role             = aws_iam_role.lambda.arn
  handler          = "asset_processor.handler"
  runtime          = "python3.12"
  source_code_hash = filebase64sha256("${path.module}/../../../lambda/asset_processor.zip")

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic,
    aws_cloudwatch_log_group.lambda
  ]

  tags = {
    Name = "bedrock-asset-processor"
  }
}

# Lambda permission for S3 to invoke it
resource "aws_lambda_permission" "s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.asset_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_bucket_arn
}
