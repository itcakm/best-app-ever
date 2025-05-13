provider "aws" {
  region = var.aws_region
}

module "networking" {
  source = "./modules/networking"
  
  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
  availability_zones  = var.availability_zones
}

module "compute" {
  source = "./modules/compute"
  
  project_name       = var.project_name
  vpc_id             = module.networking.vpc_id
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  web_sg_id          = module.networking.web_sg_id
  app_sg_id          = module.networking.app_sg_id
  web_instance_type  = var.web_instance_type
  app_instance_type  = var.app_instance_type
  web_instance_count = var.web_instance_count
  app_instance_count = var.app_instance_count
  key_name           = var.key_name
}

module "database" {
  source = "./modules/database"
  
  project_name          = var.project_name
  vpc_id                = module.networking.vpc_id
  database_subnet_ids   = module.networking.database_subnet_ids
  db_sg_id              = module.networking.db_sg_id
  db_instance_class     = var.db_instance_class
  db_allocated_storage  = var.db_allocated_storage
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
}
