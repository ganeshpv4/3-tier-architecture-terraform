# List of CIDR blocks allowed to access the ALB on HTTP
variable "allowed_http_cidrs" {
  description = "List of CIDR blocks allowed to access the ALB on HTTP"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# List of CIDR blocks allowed to access the ALB on HTTPS
variable "allowed_https_cidrs" {
  description = "List of CIDR blocks allowed to access the ALB on HTTPS"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Enable deletion protection for the ALB
variable "enable_deletion_protection" {
  description = "Enable deletion protection for the ALB"
  type        = bool
  default     = false
}

# Port for the ALB target group
variable "target_group_port" {
  description = "Port for the ALB target group"
  type        = number
  default     = 80
}

# Protocol for the ALB target group
variable "target_group_protocol" {
  description = "Protocol for the ALB target group"
  type        = string
  default     = "HTTP"
}

# Health check path for the target group
variable "health_check_path" {
  description = "Health check path for the target group"
  type        = string
  default     = "/"
}

# Health check interval in seconds
variable "health_check_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 30
}

# Health check timeout in seconds
variable "health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5
}

# Number of consecutive successful health checks before considering an instance healthy
variable "health_check_healthy_threshold" {
  description = "Number of consecutive successful health checks before considering an instance healthy"
  type        = number
  default     = 3
}

# Number of consecutive failed health checks before considering an instance unhealthy
variable "health_check_unhealthy_threshold" {
  description = "Number of consecutive failed health checks before considering an instance unhealthy"
  type        = number
  default     = 3
}

# Matcher for health check response codes
variable "health_check_matcher" {
  description = "Matcher for health check response codes"
  type        = string
  default     = "200"
}

# SSL policy for HTTPS listener
variable "ssl_policy" {
  description = "SSL policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

# ARN of the SSL certificate for HTTPS listener
variable "lb_certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS listener"
  type        = string
  default     = null
}

# Name of the application
variable "application_name" {
  description = "Name of the application"
  type        = string
}

# Deployment environment (e.g., Development, Staging, Production)
variable "environment" {
  description = "Deployment environment (e.g., Development, Staging, Production)"
  type        = string
}

# Common tags for all resources
variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

# IDs of public subnets for the ALB
variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

# VPC ID where the ALB will be created
variable "vpc_id" {
  description = "VPC ID where the ALB will be created"
  type        = string
}
