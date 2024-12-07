
# Terraform 3-Tier Architecture with ECS, Load Balancer, RDS, and Amplify Frontend

This Terraform project sets up a 3-tier architecture in AWS, consisting of:

1. **Networking Module**: Creates VPC, subnets, and security groups.
2. **ECS Module**: Configures ECS for running containerized applications.
3. **RDS Module**: Sets up an RDS database for storing application data.
4. **Load Balancer Module**: Manages traffic routing using an Application Load Balancer (ALB).
5. **Amplify Frontend Module**: Integrates a frontend app deployed via AWS Amplify.

## Architecture Overview

- **VPC and Networking**: Creates a custom VPC with public and private subnets, security groups, and routes.
- **ECS Cluster**: Deploys a Docker container in ECS, connected to the Load Balancer and specific security groups.
- **RDS**: Sets up an RDS instance (e.g., Aurora Serverless or MySQL).
- **Load Balancer**: Uses an ALB to route HTTP/HTTPS traffic to ECS containers.
- **Amplify Frontend**: Hosts a frontend application with AWS Amplify, connected to the backend ECS services.

## Requirements

- Terraform 1.0 or higher
- AWS CLI installed and configured
- GitHub OAuth Token (for Amplify integration)

## Setup Instructions

### 1. Clone the Repository

Clone this repository to your local machine:

```bash
git clone https://github.com/your-username/your-repository-name.git
cd your-repository-name
```

### 2. Initialize Terraform

Run the following command to initialize the Terraform project and download the necessary provider plugins:

```bash
terraform init
```

### 3. Configure Variables

The project uses a set of variables defined in `dev.tfvars`. Edit this file to provide values for your environment.

Example of `dev.tfvars`:

```hcl
# VPC Configuration
cidr_block_vpc         = "10.0.0.0/16"
public_subnets_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets_cidrs  = ["10.0.3.0/24", "10.0.4.0/24"]

# ECS Configuration
ecs_cluster_name       = "dev-ecs-cluster"
ecs_task_execution_role = "arn:aws:iam::123456789012:role/ecs-task-execution-role"

# Amplify Configuration
amplify_app_name       = "my-dev-amplify-app"
git_repo_url           = "https://github.com/username/repository-name.git"
github_oauth_token     = "your-oauth-token-here"

# RDS Configuration
db_username            = "admin"
db_name                = "devdb"
rds_instance_class     = "db.serverless"  # Choose your RDS instance class (e.g., db.m5.large)

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
```

### 4. Apply Terraform Configuration

Run the following command to apply the Terraform configuration and provision your infrastructure:

```bash
terraform apply -var-file=dev.tfvars
```

You will be prompted to confirm that you want to apply the configuration. Type `yes` to proceed.

### 5. Access the Application

Once the infrastructure is created, Terraform will output the DNS name of your Application Load Balancer. You can access the deployed frontend and backend services via the provided URL.

Example output:

```
application_lb_dns = "your-alb-dns-name.amazonaws.com"
```

Open your browser and navigate to the provided URL to access the application.

### 6. Tear Down the Infrastructure

To destroy the infrastructure created by Terraform, run the following command:

```bash
terraform destroy -var-file=dev.tfvars
```

### Modules Overview

- **modules/networking**: Handles the VPC, subnets, security groups, and other networking resources.
- **modules/ecs**: Configures ECS, including task definitions, clusters, and containerized services.
- **modules/rds**: Sets up the RDS database instance with proper configuration.
- **modules/load-balancer**: Manages the ALB, including listener rules and target groups.
- **modules/amplify-frontend**: Sets up AWS Amplify for frontend hosting and connects to the backend services.

### Outputs

The following outputs are available after applying the Terraform configuration:

- `application_lb_dns`: DNS name of the Application Load Balancer (ALB).
- `rds_endpoint`: Endpoint of the RDS database.

Example output:

```
application_lb_dns = "your-alb-dns-name.amazonaws.com"
rds_endpoint = "devdb.cluster-c8d2h3h2lq58.us-west-2.rds.amazonaws.com"
```

### Troubleshooting

- **ECS Container Issues**: Check the ECS task logs for any errors related to your container.
- **Amplify Integration**: Ensure that your GitHub OAuth token is correct and that your Git repository is publicly accessible.
- **RDS Connectivity**: Ensure that the RDS security group allows inbound traffic from your ECS instances.

### Additional Information

- This project is designed to be modular and can be expanded with more resources like S3, SNS, etc.
- Ensure that your AWS IAM role has sufficient permissions to create resources like VPC, EC2, ECS, ALB, RDS, and Amplify.

---

### License

MIT License (or specify the appropriate license for your project)
