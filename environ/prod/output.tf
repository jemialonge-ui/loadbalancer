output "ssh_prod1_command" { 
  description         = "command to get into the server"
  value               = "${module.ec2_prod1.ssh_command}"
  #depends_on          = [module.ec2_prod1.ip_addr, module.key_pair_dev.key_pair_filename]
}

output "ip_address_prod1" {
  description       = "The public IP address of the EC2 instance"
  value             = module.ec2_prod1.ip_addr
}

output "ssh_prod2_command" { 
  description         = "command to get into the EC2 prod2 server"
  value               = "${module.ec2_prod2.ssh_command}"
  #depends_on          = [module.ec2_prod2.ip_addr, module.key_pair_dev.key_pair_filename]
}

output "ip_address_prod2" {
  description       = "The public IP address of the EC2 instance"
  value             = module.ec2_prod2.ip_addr
}

output "prod_loadbalancer_dns" {
  description       = "The DNS name of the load balancer"
  value             = module.alb_prod.loadbalancer_dns
}