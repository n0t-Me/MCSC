resource "aws_ecr_repository" "isura" {
  name                 = "isura"
  image_tag_mutability = "MUTABLE"
}
