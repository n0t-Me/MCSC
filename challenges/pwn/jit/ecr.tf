resource "aws_ecr_repository" "jit" {
  name                 = "jit"
  image_tag_mutability = "MUTABLE"
}
