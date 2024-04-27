resource "aws_lb_target_group" "blaze" {
  name        = "blaze"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    matcher = "200-399"
  }
}

resource "aws_lb_listener_rule" "blaze_host_header" {
  listener_arn = var.lb_listener_arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blaze.arn
  }

  condition {
    host_header {
      values = ["blaze.not-me.tech"]
    }
  }
}
