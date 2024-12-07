resource "aws_ecs_cluster" "ecs_cluster" {
  for_each = { for cluster in var.ecs_clusters : cluster.name => cluster }
  name = "${each.key}-${terraform.workspace}-cluster"
}

resource "aws_ecs_task_definition" "ecs_td" {
  for_each = { for cluster in var.ecs_clusters : cluster.name => cluster }
  family                  = each.value.task_family
  network_mode            = each.value.task_config.network_mode
  requires_compatibilities = [ "FARGATE" ]
  cpu                     = each.value.task_config.cpu
  memory                  = each.value.task_config.memory

  container_definitions = jsonencode([{
    name      = each.value.task_config.container_name
    image     = each.value.task_config.image
    cpu       = each.value.task_config.cpu
    memory    = each.value.task_config.memory
    essential = true
    environment = [
    for env_var in each.value.task_config.env : {
      name  = env_var.name
      value = env_var.value
    }
  ]
    portMappings = [{
      containerPort = each.value.task_config.port
      hostPort      = each.value.task_config.port
    }]
  }])
}

resource "aws_ecs_service" "ecs_service" {
  for_each = { for cluster in var.ecs_clusters : cluster.name => cluster }

  name            = "${each.key}-service"
  cluster         = aws_ecs_cluster.ecs_cluster[each.key].id
  task_definition = aws_ecs_task_definition.ecs_td[each.key].arn
  desired_count   = each.value.desired_count
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = module.load_balancer.ecs_target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = var.security_group_id
    assign_public_ip = false
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  for_each = { for cluster in var.ecs_clusters : cluster.name => cluster }

  max_capacity       = each.value.scaling_max_capacity
  min_capacity       = each.value.scaling_min_capacity
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster[each.key].name}/${aws_ecs_service.ecs_service[each.key].name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale_up_policy" {
  for_each = { for cluster in var.ecs_clusters : cluster.name => cluster }

  name               = "${terraform.workspace}-scale-up-${each.key}"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = each.value.scaling_policies.cooldown
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = each.value.scaling_policies.lower_bound
      scaling_adjustment          = each.value.scaling_policies.scale_up_adjustment
    }
  }
}

resource "aws_appautoscaling_policy" "scale_down_policy" {
  for_each = { for cluster in var.ecs_clusters : cluster.name => cluster }

  name               = "${terraform.workspace}-scale-down-${each.key}"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = each.value.scaling_policies.cooldown
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = each.value.scaling_policies.upper_bound
      scaling_adjustment          = each.value.scaling_policies.scale_down_adjustment
    }
  }
}
