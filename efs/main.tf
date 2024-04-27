resource "aws_efs_file_system" "ctfd" {
  tags = {
    Name = "ctfd"
  }
}

module "efs_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/nfs"
  version = "~> 5.0"

  name        = "efs_ctfd"
  description = "Security group to allow EFS from ECS"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = ["10.0.0.0/16"]

}

resource "aws_efs_mount_target" "ctfd1" {
  file_system_id  = aws_efs_file_system.ctfd.id
  subnet_id       = var.subnets[0]
  security_groups = [module.efs_sg.security_group_id]
}

resource "aws_efs_mount_target" "ctfd2" {
  file_system_id  = aws_efs_file_system.ctfd.id
  subnet_id       = var.subnets[1]
  security_groups = [module.efs_sg.security_group_id]
}

resource "aws_efs_mount_target" "ctfd3" {
  file_system_id  = aws_efs_file_system.ctfd.id
  subnet_id       = var.subnets[2]
  security_groups = [module.efs_sg.security_group_id]
}

resource "aws_efs_access_point" "ctfd" {
  file_system_id = aws_efs_file_system.ctfd.id
  posix_user {
    gid = 1337
    uid = 1337
  }
  root_directory {
    path = "/ctfd"
    creation_info {
      owner_gid   = 1337
      owner_uid   = 1337
      permissions = 0777
    }
  }
  tags = {
    Name = "ctfd"
  }
}
