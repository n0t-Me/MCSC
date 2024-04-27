resource "aws_ecr_repository" "ctfd" {
  name                 = "ctfd"
  image_tag_mutability = "MUTABLE"
}
