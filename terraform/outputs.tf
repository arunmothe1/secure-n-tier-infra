output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "database_subnet_ids" {
  value = module.vpc.database_subnet_ids
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "target_group_arn" {
  value = module.alb.target_group_arn
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "jenkins_instance_id" {
  value = module.ec2.jenkins_instance_id
}

output "jenkins_public_ip" {
  value = module.ec2.jenkins_public_ip
}

output "autoscaling_group_name" {
  value = module.ec2.autoscaling_group_name
}

output "mongodb_private_ips" {
  value = module.ec2.mongodb_private_ips
}

output "mongodb_port" {
  value = 27017
}