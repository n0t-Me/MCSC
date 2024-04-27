resource "aws_ecr_repository" "warmup" {
  name                 = "warmup"
  image_tag_mutability = "MUTABLE"
}
