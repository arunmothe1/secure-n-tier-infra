output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_app[*].id
}

output "database_subnet_ids" {
  value = aws_subnet.database[*].id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.this.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.this.id
}

output "nat_gateway_public_ip" {
  value = aws_eip.nat.public_ip
}