output "challs_listener" {
  value = aws_lb_listener.challs_listener.arn
}

output "lb_arn" {
  value = aws_lb.challs_alb.arn
}
