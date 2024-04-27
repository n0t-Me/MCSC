resource "aws_lb_target_group" "warmup" {
  name        = "warmup"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    matcher = "200-399"
  }
}

resource "aws_lb_listener_rule" "warmup_host_header" {
  listener_arn = var.lb_listener_arn
  priority     = 98

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.warmup.arn
  }

  condition {
    host_header {
      values = ["warmup.not-me.tech"]
    }
  }
}
