variable "vpc_name" {
    description = "The name of the VPC"
    type        = string
    default     = "dev_project_vpc"
}

variable "env_name" {
    description = "The name of the environment"
    type        = string
    default     = "dev"
}

variable "cidr_block" {
    description = "The CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/16"
}

variable "region_name" {
    description = "The AWS region to deploy the VPC in"
    type        = string
    default     = "us-east-1"
}

variable "availabilityzone_suffix" {
    description = "The availability zone to deploy the VPC in"
    type        = list(string)
    default     = ["a"]
}

#variable "public_cidr_block1" {
#    description = "The CIDR block for the public subnet"
#    type        = string
#    default = "10.0.1.0/24"
#}

#variable "availabilityzone2" {
#    description = "The availability zone to deploy the second public subnet in"
#    type        = string
#    default     = "b"
#}

#variable "public_cidr_block2" {
#    description = "The CIDR block for the second public subnet"
#    type        = string
#    default     = "10.0.3.0/24"
#}

#variable "number_of_subnets" {
#    description = "The number of subnets to create in the VPC"
#    type        = number
#    default     = 2
#}

variable "cidrs_for_public_subnets" {
    description = "The CIDR blocks for the public subnets"
    type        = list(string)
    default     = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "cidrs_for_private_subnets" {
    description = "The CIDR blocks for the private subnets"
    type        = list(string)
    default     = ["10.0.2.0/24", "10.0.4.0/24"]
}

variable "env-name" {
    description = "The name of the environment"
    type        = string
    default     = "dev"  
}