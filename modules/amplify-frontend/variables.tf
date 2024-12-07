variable "amplify_app_name" {
  description = "Name of the amplify app"
}

variable "git_repo_url" {
  description = "Value of the GitHub repository URL"
}

variable "github_oauth_token" {
  description = "Value of Auth token of GitHub"
  type        = string
  sensitive   = true  # Marked as sensitive to avoid it being shown in logs/output
}

variable "environment" {
  description = "Deployment environment (e.g., Development, Staging, Production)"
  type        = string
  default     = "Development"
}

variable "branch_name" {
  description = "The branch name to deploy from GitHub"
  type        = string
  default     = "Development"
}
