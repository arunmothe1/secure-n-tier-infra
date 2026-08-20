module "ec2" {
  source = "./modules/ec2"

  project_name = var.project_name
  environment  = var.environment

  key_name = var.key_name

  jenkins_instance_type = var.jenkins_instance_type
  app_instance_type     = var.app_instance_type
  db_instance_type      = var.db_instance_type

  public_subnet_id = module.vpc.public_subnet_id

  app_subnet_id = module.vpc.private_app_subnet_id

  db_subnet_id = module.vpc.private_db_subnet_id

  jenkins_security_group_id = module.security_group.jenkins_sg_id
  app_security_group_id     = module.security_group.app_sg_id
  db_security_group_id      = module.security_group.db_sg_id
}