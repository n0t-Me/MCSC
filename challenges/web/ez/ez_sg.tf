resource "aws_security_group" "ez" {
  name        = "ez public-facing rules"
  description = "rules for allowing inbound from the public internet"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from public internet"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
