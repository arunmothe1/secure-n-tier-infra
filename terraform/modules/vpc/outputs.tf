output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "Primary public subnet ID"
  value       = aws_subnet.public.id
}

output "public_subnet_2_id" {
  description = "Secondary public subnet ID"
  value       = aws_subnet.public_2.id
}

output "private_app_subnet_id" {
  description = "Private application subnet ID"
  value       = aws_subnet.private_app.id
}

output "private_db_subnet_id" {
  description = "Private database subnet ID"
  value       = aws_subnet.private_db.id
}