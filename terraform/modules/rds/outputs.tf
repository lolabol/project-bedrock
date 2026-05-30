output "mysql_endpoint" {
  description = "MySQL RDS endpoint"
  value       = aws_db_instance.mysql.endpoint
}

output "mysql_host" {
  description = "MySQL RDS host"
  value       = aws_db_instance.mysql.address
}

output "postgresql_endpoint" {
  description = "PostgreSQL RDS endpoint"
  value       = aws_db_instance.postgresql.endpoint
}

output "postgresql_host" {
  description = "PostgreSQL RDS host"
  value       = aws_db_instance.postgresql.address
}

output "db_secret_arn" {
  description = "ARN of the database password secret"
  value       = aws_secretsmanager_secret.db_password.arn
}

output "rds_security_group_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds.id
}
