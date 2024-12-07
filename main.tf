module "networking" {
  source = "./modules/networking"
  
  cidr_block_vpc         = var.cidr_block_vpc
  public_subnets_cidrs   = var.public_subnets_cidrs
  private_subnets_cidrs  = var.private_subnets_cidrs
  sg_rds                 = var.sg_rds
  sg_ecs                 = var.sg_ecs
}

module "ecs" {
  source = "./modules/ecs"
  
  vpc_id                     = module.networking.vpc_main.id
  private_subnet_ids         = module.networking.private_subnet_ids
  ecs_cluster_name           = var.ecs_cluster_name
  ecs_task_execution_role    = var.ecs_task_execution_role
  security_group_id          = [module.networking.sg_ecs.id]
  alb_target_group_arn       = module.load-balancer.target_group_arn
  container_name             = var.container_name
  container_port             = var.container_port
}

module "load_balancer" {
  source = "./modules/load-balancer"

  vpc_id                      = module.networking.vpc_id
  public_subnet_ids           = module.networking.public_subnet_ids
  environment                 = var.environment
  allowed_http_cidrs         = var.allowed_http_cidrs
  allowed_https_cidrs        = var.allowed_https_cidrs
  lb_certificate_arn         = var.lb_certificate_arn
  enable_deletion_protection = var.enable_deletion_protection
  application_name           = var.application_name
  target_group_port           = var.target_group_port
  target_group_protocol       = var.target_group_protocol
  health_check_path           = var.health_check_path
  health_check_interval       = var.health_check_interval
  health_check_timeout        = var.health_check_timeout
  health_check_healthy_threshold = var.health_check_healthy_threshold
  health_check_unhealthy_threshold = var.health_check_unhealthy_threshold
  health_check_matcher        = var.health_check_matcher

  ssl_policy                  = var.ssl_policy
  common_tags                 = var.common_tags
}

module "amplify" {
  source = "./modules/amplify-frontend"
  
  amplify_app_name     = var.amplify_app_name
  git_repo_url         = var.git_repo_url
  github_oauth_token   = var.github_oauth_token
}

module "rds" {
  source = "./modules/rds"
  
  db_username          = var.db_username
  db_name              = var.db_name
  security_group_id    = module.networking.sg_rds.id
  private_subnet_ids   = module.networking.private_subnet_ids
  rds_instance_class   = var.rds_instance_class
}
