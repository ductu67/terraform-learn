output "app_asg" {
  value = aws_autoscaling_group.tier_app
}

output "app_backend_asg" {
  value = aws_autoscaling_group.tier_backend
}