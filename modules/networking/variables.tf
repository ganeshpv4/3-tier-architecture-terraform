variable "cidr_block_vpc" {
  description = "Value of the cidr range of VPC"
}

variable "public_subnets_cidrs" {
  type        = list(string)
  description = "Set of public subnets cidrs"
}

variable "private_subnets_cidrs" {
  type        = list(string)
  description = "Set of private subnet cidrs"
}

variable "sg_rds" {
  description = "Name of the SG used for RDS"
}

variable "sg_ecs" {
  description = "Name of the SG used for ECS tasks"
}

variable "environment" {
  description = "Deployment environment (e.g., Development, Staging, Production)"
  type        = string
  default     = "Development"
}
