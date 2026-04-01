output "ssh_qa1_command" { 
  description         = "command to get into the server"
  value               = "${module.ec2_qa1.ssh_command}"
}

output "ip_address_qa1" {
  description       = "The public IP address of the EC2 instance"
  value             = module.ec2_qa1.ip_addr
}

output "ssh_qa2_command" { 
  description         = "command to get into the EC2 qa2 server"
  value               = "${module.ec2_qa2.ssh_command}"
}

output "ip_address_qa2" {
  description       = "The public IP address of the EC2 instance"
  value             = module.ec2_qa2.ip_addr
}

output "qa_loadbalancer_dns" {
  description       = "The DNS name of the load balancer"
  value             = module.alb_qa.loadbalancer_dns
}