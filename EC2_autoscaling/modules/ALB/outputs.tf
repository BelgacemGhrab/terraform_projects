output "alb_sg_id" {
  description = "ALB Security Group ID"
  value       = aws_security_group.alb_sg.id 
}

output "alb_target_group_arn" {
  description = "ALB target group arn"
  value       = aws_lb_target_group.alb_target_group.arn
}