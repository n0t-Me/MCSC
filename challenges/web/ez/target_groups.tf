resource "aws_lb_target_group" "ez" {
  name        = "ez"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    matcher = "200-399"
  }
}

resource "aws_lb_listener_rule" "ez_host_header" {
  listener_arn = var.lb_listener_arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ez.arn
  }

  condition {
    host_header {
      values = ["ez.not-me.tech"]
    }
  }
}
