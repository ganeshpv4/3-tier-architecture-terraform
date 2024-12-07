variable "db_username" {
  description = "Username of RDS"
  type        = string
  sensitive   = true
}


variable "db_name" {
  description = "Name of the database"
  type = string
}

variable "security_group_id" {
  description = "ID of the security group for RDS serverless cluster"
  type = string
}

variable "private_subnet_ids" {
  description = "Private subnets IDs"
  type = list(string)
}

variable "rds_instance_class" {
  description = "Instance class of the RDS"
  type        = string
  default     = "db.serverless"
}

variable "environment" {
  description = "Deployment environment (e.g., Development, Staging, Production)"
  type        = string
  default     = "Development"
}
