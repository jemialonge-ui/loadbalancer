variable "region_name" {
    description = "The region in which the load balancer will be on"
}

variable "vpc_id" {
    description = "The VPC ID where the load balancer will be created"
}

variable "subnet_ids" {
    description = "The IDs of the subnets where the load balancer will be created"
}

#variable "availability_zone_suffix" {
#    description = "The suffix for the availability zones"
#}

variable "security_groups_for_lb_id" {
    description = "The IDs of the security groups for the load balancer"
}

variable "ec2_dns" { 
    description = "The DNS names of the EC2 instances"
    type        = list(string)
}

variable "ec2_ids" { 
    description = "The IDs of the EC2 instances"
    type        = list(string)
}