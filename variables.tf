variable "aws_desired_region" {
  description = "Name of the desired AWS region"
}

variable "backend_bucket_region" {
  description = "The region where the Terraform state S3 bucket is located."
  type        = string
  default     = "us-west-2"
}


variable "cidr_block_vpc" {
  description = "Value of the cidr range of VPC"
  type        = string
}

variable "public_subnets_cidrs" {
  description = "Set of public subnets CIDRs"
  type        = list(string)
}

variable "private_subnets_cidrs" {
  description = "Set of private subnets CIDRs"
  type        = list(string)
}

variable "sg_rds" {
  description = "Name of the SG used for RDS"
  type        = string
}

variable "sg_ecs" {
  description = "Name of the SG used for ECS"
  type = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "ecs_task_execution_role" {
  description = "ECS Task Execution Role"
  type        = string
}

variable "container_name" {
  description = "The name of the ECS container"
  type        = string
}

variable "container_port" {
  description = "The port on which the ECS container listens"
  type        = number
  default     = 8080
}

variable "amplify_app_name" {
  description = "Name of the Amplify app"
  type        = string
}

variable "git_repo_url" {
  description = "GitHub repository URL"
  type        = string
}

variable "github_oauth_token" {
  description = "GitHub OAuth token"
  type        = string
}

variable "db_username" {
  description = "RDS Database username"
  type        = string
}

variable "db_name" {
  description = "Name of the RDS database"
  type        = string
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.serverless"
}

variable "environment" {
  description = "Deployment environment (e.g., Development, Staging, Production)"
  type        = string
  default     = "Development"
}

variable "allowed_http_cidrs" {
  description = "List of CIDR blocks allowed to access the ALB on HTTP"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_https_cidrs" {
  description = "List of CIDR blocks allowed to access the ALB on HTTPS"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the ALB"
  type        = bool
  default     = false
}

variable "target_group_port" {
  description = "Port for the ALB target group"
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "Protocol for the ALB target group"
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "Health check path for the target group"
  type        = string
  default     = "/"
}

variable "health_check_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5
}

variable "health_check_healthy_threshold" {
  description = "Number of consecutive successful health checks before considering an instance healthy"
  type        = number
  default     = 3
}

variable "health_check_unhealthy_threshold" {
  description = "Number of consecutive failed health checks before considering an instance unhealthy"
  type        = number
  default     = 3
}

variable "health_check_matcher" {
  description = "Matcher for health check response codes"
  type        = string
  default     = "200"
}

variable "ssl_policy" {
  description = "SSL policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

variable "lb_certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS listener"
  type        = string
  default     = null
}

variable "application_name" {
  description = "Name of the application"
  type        = string
  default     = "MyApp"
}

variable "common_tags" {
  description = "Map of common tags for all resources"
  type        = map(string)
  default     = {}
}