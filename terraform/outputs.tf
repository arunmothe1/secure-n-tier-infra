output "jenkins_public_ip" {
  description = "Public IP of Jenkins Control Server"
  value       = module.ec2.jenkins_public_ip
}