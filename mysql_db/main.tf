resource "random_password" "random" {
  length = 22
  # URI constraints FTL :sob:
  special = false
  lifecycle {
    ignore_changes = all
  }
}

resource "aws_db_instance" "default" {
  #vpc_id                  = var.vpc_id
  allocated_storage           = var.allocated_storage
  engine                      = "mysql"
  engine_version              = "8.0"
  instance_class              = "db.t3.micro"
  db_name                     = "ctfd"
  username                    = "ctfd"
  password                    = random_password.random.result
  parameter_group_name        = "default.mysql8.0"
  backup_retention_period     = 5
  copy_tags_to_snapshot       = true
  skip_final_snapshot         = true
  db_subnet_group_name        = aws_db_subnet_group.default.id
  vpc_security_group_ids      = var.sg_ids
  allow_major_version_upgrade = true
  apply_immediately           = true
}

resource "aws_ssm_parameter" "db_uri" {
  name  = "/ctfd/db_uri"
  type  = "SecureString"
  value = "mysql+pymysql://ctfd:${random_password.random.result}@${aws_db_instance.default.endpoint}/ctfd"
}

resource "aws_db_subnet_group" "default" {
  name       = "ctfd-main"
  subnet_ids = var.db_subnets
}

