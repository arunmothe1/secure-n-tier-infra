module "security_group" {
  source      = "./modules/security-group"
  vpc_id      = module.vpc.vpc_id
  environment = var.environment
}