variable "project_name" {
  description = "Project name"
  type        = string
}

variable "s3_bucket_arn" {
  description = "S3 bucket ARN that triggers Lambda"
  type        = string
}

variable "s3_bucket_id" {
  description = "S3 bucket ID"
  type        = string
}
