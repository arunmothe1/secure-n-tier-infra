output "jenkins_instance_id" {
  value = aws_instance.jenkins.id
}

output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "jenkins_private_ip" {
  value = aws_instance.jenkins.private_ip
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.app.name
}

output "launch_template_id" {
  value = aws_launch_template.app.id
}

output "app_iam_role_name" {
  value = aws_iam_role.app.name
}

output "jenkins_iam_role_name" {
  value = aws_iam_role.jenkins.name
}

output "mongodb_instance_ids" {
  value = aws_instance.mongodb[*].id
}

output "mongodb_private_ips" {
  value = aws_instance.mongodb[*].private_ip
}