variable "security_group_name" {
    description = "The name of the security group"
    type        = string
    default     = "dev_ec2_web_sg"
}

variable "project_name" {
    description = "The name of the project"
    type        = string
    default     = "dev_project"
}

variable "vpc_id" {
    description = "The ID of the VPC to associate the security group with"
    type        = string
}
