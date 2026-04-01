output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main_vpc.id
}

output "Private_subnet_ids" { 
  description = "The IDs of the private subnets"
  value       = [ for subnet in aws_subnet.private_subnet : subnet.id ]
}

output "Public_subnet_ids" { 
  description = "The ID of the public subnet"
  value       = [ for subnet in aws_subnet.public_subnet : subnet.id ]
}

output "vpc_region" {
  description = "The region where the VPC is deployed"
  value       = var.region_name
}

output "vpc_availability_zones" {
  description = "The availability zones where the VPC is deployed"
  value       = [ for az in var.availabilityzone_suffix : "${var.region_name}${az}" ]
}