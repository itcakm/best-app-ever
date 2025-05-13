variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs of the public subnets"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "IDs of the private subnets"
  type        = list(string)
}

variable "web_sg_id" {
  description = "ID of the web security group"
  type        = string
}

variable "app_sg_id" {
  description = "ID of the app security group"
  type        = string
}

variable "web_instance_type" {
  description = "Instance type for web servers"
  type        = string
}

variable "app_instance_type" {
  description = "Instance type for application servers"
  type        = string
}

variable "web_instance_count" {
  description = "Number of web server instances"
  type        = number
}

variable "app_instance_count" {
  description = "Number of application server instances"
  type        = number
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}
