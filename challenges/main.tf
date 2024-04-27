module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "challs-vpc"
  cidr = "12.0.0.0/16"

  azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
  #intra_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets = ["12.0.101.0/24", "12.0.102.0/24", "12.0.103.0/24"]

  single_nat_gateway     = false
  one_nat_gateway_per_az = true
  create_igw             = true

  #enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Name      = "challs-vpc"
  }
}

resource "awscc_ecs_cluster" "challs" {
  cluster_name = "challs"
  service_connect_defaults = {
    namespace = "challs"
  }
}

module "load_balancer" {
  source  = "./load_balancer"
  subnets = module.vpc.public_subnets
  vpc_id  = module.vpc.vpc_id
}

module "blaze_chall" {
  source             = "./web/blaze"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  lb_listener_arn    = module.load_balancer.challs_listener
  cluster            = awscc_ecs_cluster.challs.id
  execution_role_arn = var.execution_role
  task_role_arn      = var.task_role
  memory             = "2048"
  cpu                = "1024"
  service_depends_on = [awscc_ecs_cluster.challs]
  cluster_name       = awscc_ecs_cluster.challs.cluster_name
}

module "ez_chall" {
  source             = "./web/ez"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  lb_listener_arn    = module.load_balancer.challs_listener
  cluster            = awscc_ecs_cluster.challs.id
  execution_role_arn = var.execution_role
  task_role_arn      = var.task_role
  memory             = "1024"
  cpu                = "512"
  service_depends_on = [awscc_ecs_cluster.challs]
  cluster_name       = awscc_ecs_cluster.challs.cluster_name
}


module "warmup_chall" {
  source             = "./web/warmup"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  lb_listener_arn    = module.load_balancer.challs_listener
  cluster            = awscc_ecs_cluster.challs.id
  execution_role_arn = var.execution_role
  task_role_arn      = var.task_role
  memory             = "1024"
  cpu                = "256"
  service_depends_on = [awscc_ecs_cluster.challs]
  cluster_name       = awscc_ecs_cluster.challs.cluster_name
}

module "jit_chall" {
  source  = "./pwn/jit"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  #lb_listener_arn    = module.load_balancer.challs_listener
  cluster            = awscc_ecs_cluster.challs.id
  execution_role_arn = var.execution_role
  task_role_arn      = var.task_role
  memory             = "1024"
  cpu                = "256"
  service_depends_on = [awscc_ecs_cluster.challs]
  cluster_name       = awscc_ecs_cluster.challs.cluster_name
}

module "isura_chall" {
  source  = "./crypto"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  #lb_listener_arn    = module.load_balancer.challs_listener
  cluster            = awscc_ecs_cluster.challs.id
  execution_role_arn = var.execution_role
  task_role_arn      = var.task_role
  memory             = "2048"
  cpu                = "1024"
  service_depends_on = [awscc_ecs_cluster.challs]
  cluster_name       = awscc_ecs_cluster.challs.cluster_name
}

module "setjmp_chall" {
  source  = "./pwn/setjmp"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  #lb_listener_arn    = module.load_balancer.challs_listener
  cluster            = awscc_ecs_cluster.challs.id
  execution_role_arn = var.execution_role
  task_role_arn      = var.task_role
  memory             = "1024"
  cpu                = "256"
  service_depends_on = [awscc_ecs_cluster.challs]
  cluster_name       = awscc_ecs_cluster.challs.cluster_name
}
