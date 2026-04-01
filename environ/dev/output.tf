output "ssh_dev1_command" { 
  description         = "command to get into the server"
  value               = "${module.ec2_dev1.ssh_command}"
  #depends_on          = [module.ec2_dev1.ip_addr, module.key_pair_dev.key_pair_filename]
}

output "ip_address_dev1" {
  description       = "The public IP address of the EC2 instance"
  value             = module.ec2_dev1.ip_addr
}

output "ssh_dev2_command" { 
  description         = "command to get into the EC2 dev2 server"
  value               = "${module.ec2_dev2.ssh_command}"
  #depends_on          = [module.ec2_dev2.ip_addr, module.key_pair_dev.key_pair_filename]
}

output "ip_address_dev2" {
  description       = "The public IP address of the EC2 instance"
  value             = module.ec2_dev2.ip_addr
}

output "dev_loadbalancer_dns" {
  description       = "The DNS name of the load balancer"
  value             = module.alb_dev.loadbalancer_dns
}

output "volume_details" {
  description = "The details of the EBS volume"
  value       = module.volume_dev.ebs_details
}

output "EC2_names" {
    description = "The names of the EC2 instances"
    value       = [module.ec2_dev1.EC2-name, module.ec2_dev2.EC2-name]  
}