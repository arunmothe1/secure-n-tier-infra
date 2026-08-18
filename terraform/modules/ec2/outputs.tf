output "jenkins_public_ip" {
  description = "Public IP of Jenkins Server"
  value       = aws_instance.jenkins.public_ip
}

output "app_instance_ids" {
  description = "IDs of App Instances"
  value       = aws_instance.app[*].id
}

output "db_instance_id" {
  description = "ID of DB Instance"
  value       = aws_instance.db.id
}