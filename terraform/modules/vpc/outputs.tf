output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of Public Subnet IDs"
  value       = aws_subnet.public[*].id
}

output "app_subnet_ids" {
  description = "List of Private App Subnet IDs"
  value       = aws_subnet.private_app[*].id
}

output "db_subnet_id" {
  description = "Private DB Subnet ID"
  value       = aws_subnet.private_db.id
}