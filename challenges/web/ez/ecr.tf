resource "aws_ecr_repository" "ez" {
  name                 = "ez"
  image_tag_mutability = "MUTABLE"
}
