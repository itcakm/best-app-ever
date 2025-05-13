variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "database_subnet_ids" {
  description = "IDs of the database subnets"
  type        = list(string)
}

variable "db_sg_id" {
  description = "ID of the database security group"
  type        = string
}

variable "db_instance_class" {
  description = "Instance class for the RDS database"
  type        = string
}

variable "db_allocated_storage" {
  description = "Allocated storage for the database (in GB)"
  type        = number
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
}

variable "db_password" {
  description = "Master password for the database"
  type        = string
}
