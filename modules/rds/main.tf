resource "random_password" "rds_password" {
  length              = 16
  special             = true
  override_special    = "_%@#$!^&*()-+=[]{}"
}


resource "aws_kms_key" "rds_secrets_key" {
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "rds_secrets_alias" {
  name = "alias/rds-secrets-key"
  target_key_id = aws_kms_key.rds_secrets_key.id
}

resource "aws_secretsmanager_secret" "rds_credentials" {
  name = "db-credentials"
  kms_key_id = aws_kms_key.rds_secrets_key.arn
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = aws_secretsmanager_secret.rds_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.rds_password.result
  })
}

# Aurora Serverless Cluster
resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = "aurora-serverless-cluster"
  engine                 = "aurora-mysql"
  engine_mode            = "serverless"
  master_username        = var.db_username
  master_password        = random_password.rds_password.result
  database_name          = var.db_name
  backup_retention_period = 7
  storage_encrypted      = true
  kms_key_id             = aws_kms_key.rds_secrets_key.arn

  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name

  scaling_configuration {
    min_capacity = 2
    max_capacity = 16
  }
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  cluster_identifier = aws_rds_cluster.aurora_cluster.cluster_identifier
  instance_class     = var.rds_instance_class
  engine             = aws_rds_cluster.aurora_cluster.engine
  publicly_accessible = false
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "db-subnet-group"
    Environment = var.environment
  }
}


