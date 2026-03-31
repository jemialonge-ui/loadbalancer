output "loadbalancer_dns" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.app_lb.dns_name
}

# print the url of the webserver 1
output "webserver1_public_dns" {
    value = var.ec2_dns[0]
}
# print the url of the webserver 2
output "webserver2_public_dns" {
    value = var.ec2_dns[1]
}

output "all_webservers_public_dns" {
    value = [for ec2_instance_dns in var.ec2_dns : ec2_instance_dns]
}
