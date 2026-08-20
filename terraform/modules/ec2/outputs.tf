output "app_instance_ids" {
  value = aws_instance.app[*].id
}

output "app_private_ips" {
  value = aws_instance.app[*].private_ip
}

output "db_instance_id" {
  value = aws_instance.db.id
}

output "db_private_ip" {
  value = aws_instance.db.private_ip
}

output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}