resource "aws_lb" "challs_alb" {
  name               = "challs"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = [aws_security_group.public_facing.id]

  tags = {
    application = "challs"
  }
}

resource "aws_lb_listener" "challs_listener" {
  load_balancer_arn = aws_lb.challs_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "I am a teapot"
      status_code  = "418"
    }
  }
}

resource "aws_security_group" "public_facing" {
  name        = "challs public-facing rules"
  description = "rules for allowing inbound from the public internet"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from public internet"
    from_port   = 80
    to_port     = 80
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
