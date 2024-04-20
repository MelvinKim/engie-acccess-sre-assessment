output "alb_security_group_id" {
  value = aws_security_group.alb_security_group.id
}

output "target_group_arn" {
  value = aws_lb_target_group.application.arn
}