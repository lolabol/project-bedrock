output "dev_view_username" {
  description = "Developer IAM username"
  value       = aws_iam_user.dev_view.name
}

output "dev_view_password" {
  description = "Developer IAM console password"
  value       = aws_iam_user_login_profile.dev_view.password
  sensitive   = true
}

output "dev_view_access_key_id" {
  description = "Developer IAM access key ID"
  value       = aws_iam_access_key.dev_view.id
}

output "dev_view_secret_access_key" {
  description = "Developer IAM secret access key"
  value       = aws_iam_access_key.dev_view.secret
  sensitive   = true
}
