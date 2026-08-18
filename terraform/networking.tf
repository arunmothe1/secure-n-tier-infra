module "vpc" {
  source                  = "./modules/vpc"
  vpc_cidr                = var.vpc_cidr
  public_subnet_cidr      = var.public_subnet_cidr
  private_app_subnet_cidr = var.private_app_subnet_cidr
  private_db_subnet_cidr  = var.private_db_subnet_cidr
  environment             = var.environment
}