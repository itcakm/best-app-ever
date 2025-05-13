output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_subnet_ids" {
  value = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.networking.private_subnet_ids
}

output "database_subnet_ids" {
  value = module.networking.database_subnet_ids
}

output "web_instance_ids" {
  value = module.compute.web_instance_ids
}

output "app_instance_ids" {
  value = module.compute.app_instance_ids
}

output "web_lb_dns_name" {
  value = module.compute.web_lb_dns_name
}

output "app_lb_dns_name" {
  value = module.compute.app_lb_dns_name
}

output "db_endpoint" {
  value = module.database.db_endpoint
}
