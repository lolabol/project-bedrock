output "assets_bucket_name" {
  description = "Assets S3 bucket name"
  value       = aws_s3_bucket.assets.id
}

output "assets_bucket_arn" {
  description = "Assets S3 bucket ARN"
  value       = aws_s3_bucket.assets.arn
}

output "assets_bucket_id" {
  description = "Assets S3 bucket ID"
  value       = aws_s3_bucket.assets.id
}
