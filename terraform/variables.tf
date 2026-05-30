variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "project-bedrock"
}

variable "student_id" {
  description = "Student ID for unique S3 bucket naming"
  type        = string
  default     = "alt-soe-025-5119"
}

variable "db_password" {
  description = "Password for RDS databases"
  type        = string
  sensitive   = true
}
