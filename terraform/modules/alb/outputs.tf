output "alb_id" {
  value = aws_lb.this.id
}

output "alb_arn" {
  value = aws_lb.this.arn
}

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_arn_suffix" {
  value = aws_lb.this.arn_suffix
}

output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "target_group_name" {
  value = aws_lb_target_group.this.name
}