# Security Group for the ALB
resource "aws_security_group" "lb_security_group" {
  name        = "${var.environment}-lb-sg"
  description = "Security group for the Load Balancer"
  vpc_id      = var.vpc_id

  # Allow inbound HTTP/HTTPS traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cidrs
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_https_cidrs
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-lb-sg"
    }
  )
}

# ALB Resource
resource "aws_lb" "application_lb" {
  name               = "${var.environment}-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_security_group.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-app-lb"
    }
  )
}

# ALB Target Group
resource "aws_lb_target_group" "ecs_target_group" {
  name_prefix = "${var.environment}-ecs-tg" # Use `name_prefix` to avoid issues with unique name constraints.
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = "ip" # Assuming ECS Fargate; adjust to "instance" if using EC2.

  health_check {
    path                = var.health_check_path
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    matcher             = var.health_check_matcher
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-ecs-tg"
    }
  )
}

# ALB HTTP Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
  }
}

# ALB HTTPS Listener
resource "aws_lb_listener" "https_listener" {
  count             = var.lb_certificate_arn != null ? 1 : 0 # Dynamically create HTTPS listener.
  load_balancer_arn = aws_lb.application_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.lb_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
  }
}
