module "vpc" {
  source = "./modules/vpc"

  project_name          = var.project_name
  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  availability_zones    = var.availability_zones
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
  tags                  = local.common_tags
}

module "security_group" {
  source = "./modules/security-group"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  app_port     = var.app_port
  db_port      = var.db_port
  tags         = local.common_tags
}

module "alb" {
  source = "./modules/alb"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  security_group_id = module.security_group.alb_security_group_id
  app_port          = var.app_port
  health_check_path = var.health_check_path
  tags              = local.common_tags
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment
  tags         = local.common_tags
}

module "ec2" {
  source = "./modules/ec2"

  project_name          = var.project_name
  environment           = var.environment
  aws_region            = var.aws_region
  ami_id                = data.aws_ami.amazon_linux_2023.id
  instance_type         = var.instance_type
  jenkins_instance_type = var.jenkins_instance_type
  mongodb_instance_type = var.mongodb_instance_type

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  private_subnet_ids  = module.vpc.private_subnet_ids
  public_subnet_id    = module.vpc.public_subnet_ids[0]
  database_subnet_ids = module.vpc.database_subnet_ids

  app_security_group_id      = module.security_group.app_security_group_id
  jenkins_security_group_id  = module.security_group.jenkins_security_group_id
  database_security_group_id = module.security_group.database_security_group_id

  target_group_arn   = module.alb.target_group_arn
  ecr_repository_url = module.ecr.repository_url
  ecr_repository_arn = module.ecr.repository_arn

  tags = local.common_tags
}