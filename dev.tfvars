# VPC Configuration
cidr_block_vpc         = "10.0.0.0/16"           # CIDR range for the VPC
public_subnets_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"] # Public subnet CIDRs
private_subnets_cidrs  = ["10.0.3.0/24", "10.0.4.0/24"] # Private subnet CIDRs

# Security Group for RDS (e.g., for MySQL)
sg_rds                 = "rds-sg"                 # Name of the security group for RDS

# ECS Configuration
ecs_cluster_name       = "dev-ecs-cluster"        # Name of the ECS cluster
ecs_task_execution_role = "arn:aws:iam::123456789012:role/ecs-task-execution-role" # ECS task execution role ARN
container_name = "my-dev-container"
container_port = 8080

# Amplify Configuration
amplify_app_name       = "my-dev-amplify-app"     # Name of the Amplify app
git_repo_url           = "https://github.com/username/repository-name.git" # GitHub repository URL
github_oauth_token     = "your-oauth-token-here"  # OAuth token for GitHub integration

# RDS Configuration
db_username            = "admin"                  # RDS database username
db_name                = "devdb"                  # RDS database name
rds_instance_class     = "db.serverless"          # RDS instance class (Aurora Serverless or similar)

# Load Balancer Configurations
allowed_http_cidrs         = ["0.0.0.0/0"]  # Adjust CIDRs for HTTP traffic
allowed_https_cidrs        = ["0.0.0.0/0"]  # Adjust CIDRs for HTTPS traffic
enable_deletion_protection = false          # Set true if needed
target_group_port          = 80
target_group_protocol      = "HTTP"
health_check_path          = "/health"
health_check_interval      = 30
health_check_timeout       = 5
health_check_healthy_threshold = 3
health_check_unhealthy_threshold = 3
health_check_matcher       = "200"
ssl_policy                 = "ELBSecurityPolicy-2016-08"
lb_certificate_arn         = "arn:aws:acm:region:account-id:certificate/certificate-id"
application_name           = "MyApp"
