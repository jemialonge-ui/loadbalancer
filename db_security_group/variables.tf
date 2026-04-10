variable "security_group_name" {
    description = "The name of the security group"
    type        = string
    default     = "dev_db_sg"
}

variable "environment_name" {
    description = "The name of the environment"
    type        = string
    default     = "dev"
}

variable "vpc_id" {
    description = "The ID of the VPC to associate the security group with"
    type        = string
}

#variable "ec2_security_group_id" {
#    description = "The ID of the VPC security group to allow traffic from"
#    type        = string
#}

variable "full_vpc_cidr_block" {
    description = "The full CIDR block for the VPC"
    type        = string
}