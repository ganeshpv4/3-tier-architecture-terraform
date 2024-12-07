variable "ecs_clusters" {
  type = list(object({
    name         = string
    task_family  = string
    task_config  = object({
      cpu            = number
      memory         = number
      image          = string
      port           = number
      container_name = string
      network_mode   = string
      env            = optional(list(object({
        name  = string
        value = string
      })), [])
    })
    desired_count      = number
    scaling_max_capacity = number
    scaling_min_capacity = number
    scaling_policies   = object({
      cooldown    = number
      upper_bound = number
      lower_bound = number
      scale_up_adjustment = number
      scale_down_adjustment = number
    })
  }))
  default = [
    {
      name         = "dev-cluster"
      task_family  = "dev-task-family"
      task_config  = {
        cpu            = 512
        memory         = 1024
        image          = "my-app:dev-latest"
        port           = 8080
        container_name = "dev-container"
        network_mode   = "awsvpc"
        env = [
          { name = "APP_ENV", value = "Dev" }
        ]
      }
      desired_count      = 2
      scaling_max_capacity = 10
      scaling_min_capacity = 1
      scaling_policies   = {
        cooldown    = 60
        upper_bound = 0
        lower_bound = -1
        scale_up_adjustment = 2
        scale_down_adjustment = -1
      }
    },
    {
      name         = "stage-cluster"
      task_family  = "stage-task-family"
      task_config  = {
        cpu            = 1024
        memory         = 2048
        image          = "my-app:stage-latest"
        port           = 8080
        container_name = "stage-container"
        network_mode   = "awsvpc"
        env = [
          { name = "APP_ENV", value = "Stage" }
        ]
      }
      desired_count      = 3
      scaling_max_capacity = 15
      scaling_min_capacity = 2
      scaling_policies   = {
        cooldown    = 60
        upper_bound = 0
        lower_bound = -2
        scale_up_adjustment = 4
        scale_down_adjustment = -2
      }
    }
  ]
}

variable "private_subnet_ids" {
  type = list(string)
  description = "List of private subnet IDs where ECS tasks will be deployed."
}

variable "security_group_id" {
  type = list(string)
  description = "List of security group IDs to attach to ECS services for network access control."
}

variable "alb_target_group_arn" {
  description = "Target group ARN for ECS"
  type        = string
}

variable "container_name" {
  description = "Name of the ECS container"
  type        = string
}

variable "container_port" {
  description = "Port for the ECS container"
  type        = number
}
