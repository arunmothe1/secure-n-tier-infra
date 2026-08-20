module "alb" {
  source = "./modules/alb"

  vpc_id = module.vpc.vpc_id

  public_subnet_ids = [
    module.vpc.public_subnet_id,
    module.vpc.public_subnet_2_id
  ]

  alb_security_group_id = module.security_group.alb_sg_id

  app_instance_ids = module.ec2.app_instance_ids

  application_port = var.application_port

  environment = var.environment
}