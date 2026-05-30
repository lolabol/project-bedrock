output "carts_table_name" {
  description = "DynamoDB carts table name"
  value       = aws_dynamodb_table.carts.name
}

output "carts_table_arn" {
  description = "DynamoDB carts table ARN"
  value       = aws_dynamodb_table.carts.arn
}

output "orders_table_name" {
  description = "DynamoDB orders table name"
  value       = aws_dynamodb_table.orders.name
}

output "orders_table_arn" {
  description = "DynamoDB orders table ARN"
  value       = aws_dynamodb_table.orders.arn
}
