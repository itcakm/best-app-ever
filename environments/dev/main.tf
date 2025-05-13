provider "aws" {
  region = "us-east-1"
}

module "three_tier_architecture" {
  source = "../../"
  
  # Project Settings
  project_name = "best-app-dev"
  
  # Networking
  vpc_cidr              = "10.0.0.0/16"
  public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs  = ["10.0.3.0/24", "10.0.4.0/24"]
  database_subnet_cidrs = ["10.0.5.0/24", "10.0.6.0/24"]
  availability_zones    = ["us-east-1a", "us-east-1b"]
  
  # Compute Settings
  web_instance_type  = "t2.micro"
  app_instance_type  = "t2.small"
  web_instance_count = 2
  app_instance_count = 2
  key_name           = "best-app-dev-key"  # Make sure this key exists in your AWS account
  
  # Database Settings
  db_instance_class    = "db.t3.small"
  db_allocated_storage = 20
  db_name              = "bestappdb"
  db_username          = "dbadmin"
  db_password          = "DevPassword123!"  # Use AWS Secrets Manager or parameter store in real environments
}
