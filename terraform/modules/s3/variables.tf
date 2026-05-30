variable "project_name" {
  description = "Project name"
  type        = string
}

variable "student_id" {
  description = "Student ID for unique bucket naming"
  type        = string
}

variable "lambda_function_arn" {
  description = "Lambda function ARN to trigger on S3 events"
  type        = string
  default     = ""
}

variable "lambda_permission_id" {
  description = "Lambda permission dependency"
  type        = string
  default     = ""
}
