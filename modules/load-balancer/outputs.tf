output "application_lb_dns" {
  description = "DNS name of the application load balancer"
  value       = aws_lb.application_lb.dns_name
}

output "ecs_target_group_arn" {
  description = "ARN of the ECS target group"
  value       = aws_lb_target_group.ecs_target_group.arn
}
