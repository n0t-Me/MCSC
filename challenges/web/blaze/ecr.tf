resource "aws_ecr_repository" "blaze" {
  name                 = "blaze"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "graphql" {
  name                 = "graphql"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "blaze_bot" {
  name                 = "blaze_bot"
  image_tag_mutability = "MUTABLE"
}
