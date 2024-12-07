resource "aws_amplify_app" "frontend-app" {
  name = var.amplify_app_name
  repository = var.git_repo_url
  oauth_token = var.github_oauth_token

  custom_rule {
    source = "</*>"
    target = "/index.html"
    status = "200"
  }
  tags = {
    Environment = var.environment
  }
}

resource "aws_amplify_branch" "amplify_branch" {
  app_id = aws_amplify_app.frontend-app.id
  branch_name = var.branch_name
  enable_auto_build = true
  stage = "Development"
}