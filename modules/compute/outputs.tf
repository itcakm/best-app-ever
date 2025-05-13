output "web_instance_ids" {
  value = aws_instance.web[*].id
}

output "app_instance_ids" {
  value = aws_instance.app[*].id
}

output "web_lb_dns_name" {
  value = aws_lb.web.dns_name
}

output "app_lb_dns_name" {
  value = aws_lb.app.dns_name
}
