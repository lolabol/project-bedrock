output "lambda_function_arn" {
  description = "Lambda function ARN"
  value       = aws_lambda_function.asset_processor.arn
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.asset_processor.function_name
}

output "lambda_permission_id" {
  description = "Lambda permission ID for S3 dependency"
  value       = aws_lambda_permission.s3.id
}
