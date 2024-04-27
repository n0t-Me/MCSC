provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["~/.aws/credentials"]
}

provider "awscc" {
  region                   = "us-east-1"
  shared_credentials_files = ["~/.aws/credentials"]
}

data "aws_iam_role" "labrole" {
  name = "LabRole"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "ctfd-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["us-east-1a", "us-east-1b", "us-east-1c"]
  intra_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  #enable_nat_gateway = true
  create_igw = true

  #enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Name      = "ctfd-vpc"
  }
}

module "mysql_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/mysql"

  name        = "mysql_ctfd"
  description = "Security group for mysql"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["10.0.0.0/16"]
}

module "redis_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/redis"
  version = "~> 5.0"

  name        = "redis_ctfd"
  description = "Security group for redis"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["10.0.0.0/16"]
}



module "mysql_db" {
  source     = "./mysql_db"
  vpc_id     = module.vpc.vpc_id
  db_subnets = module.vpc.intra_subnets
  sg_ids     = [module.mysql_sg.security_group_id]
}

module "redis_cache" {
  source        = "./redis"
  redis_sg      = [module.redis_sg.security_group_id]
  redis_subnets = module.vpc.intra_subnets
}

module "alb" {
  source  = "./load_balancer"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
}

module "efs" {
  source  = "./efs"
  subnets = module.vpc.public_subnets
  vpc_id  = module.vpc.vpc_id
}

module "ctfd" {
  source             = "./ctfd"
  ctfd_version       = "latest"
  redis_url          = module.redis_cache.redis
  database_url       = module.mysql_db.db_uri
  execution_role_arn = data.aws_iam_role.labrole.arn
  task_role_arn      = data.aws_iam_role.labrole.arn
  cpu                = "1024"
  memory             = "2048"
  logs_region        = "us-east-1"
  workers            = "2"
  desired_count      = 2
  security_groups    = [module.alb.alb_to_ecs_security_group.id]
  subnets            = module.vpc.public_subnets
  target_group_arn   = module.alb.ctfd_target_group.arn
  fs_id              = module.efs.fs_id
  fs_access_point    = module.efs.fs_access_point
}

module "challs" {
  source         = "./challenges"
  execution_role = data.aws_iam_role.labrole.arn
  task_role      = data.aws_iam_role.labrole.arn
}

module "cf_records" {
  source             = "./cloudflare"
  lb_arn             = module.challs.lb_arn
  lb_ctfd_arn        = module.alb.ctfd_alb.arn
  cloudflare_zone_id = "881a36d56345ac51bcb063dfcc75f6e6"
}

