resource "aws_ecr_repository" "setjmp" {
  name                 = "setjmp"
  image_tag_mutability = "MUTABLE"
}
