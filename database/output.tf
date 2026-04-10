output "db_instance_id" {
  description = "The ID of the database instance"
  value       = aws_db_instance.db_instance.id
}

output "name" {
  description = "The name of the database instance"
  value       = aws_db_instance.db_instance.identifier
}

output "db_endpoint" {
  description = "The endpoint of the database instance"
  value       = aws_db_instance.db_instance.endpoint
}

output "port" {
  description = "The port of the database instance"
  value       = aws_db_instance.db_instance.port
}

output "db_instance_arn" {
  description = "The ARN of the database instance"
  value       = aws_db_instance.db_instance.arn
}

