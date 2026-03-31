variable "ami_id" {
    description = "The ID of the AMI to use for the EC2 instance"
    type        = string
}

variable "instance_type" {
    description = "The type of the EC2 instance"
    type        = string
}

variable "key_name_input" {
    description = "The name of the SSH key pair to use for the EC2 instance"
    type        = string
    default     = "dev-terraform-key-pair"
}

variable "subnet_id" {
    description = "The ID of the subnet to launch the EC2 instance in"
    type        = string
}

variable "vpc_id" {
    description = "The ID of the VPC to launch the EC2 instance in"
    type        = string
}

variable "volume_size" {
    description = "The size of the root EBS volume in GB"
    type        = number
    default     = 30
}

variable "ec2_instance_name" {
    description = "The name of the EC2 instance"
    type        = string
    default     = "dev-terraform-ec2-instance"
}

variable "volume_type" {
    description = "The volume type for the root EBS volume"
    type        = string
    default     = "gp2" 
}

variable "region_name" {
    description = "The AWS region to deploy the EC2 instance in"
    type        = string
    default     = "us-east-1"
}

variable "availability_zone" {
    description = "The availability zone to deploy the EC2 instance in"
    type = string
    default = "us-east-1a"
}

variable "security_group_ids" {
    description = "A list of security group IDs to associate with the EC2 instance"
    type        = list(string)
}

#variable "key_name" {
#    description = "The name of the key pair"
#    type        = string
#}

variable "rsa_number_of_bits" {
    description = "The number of bits for the RSA key"
    type        = number
    default     = 2048
}

#variable "filename" {
#    description = "The name of the file to save the private key"
#    type        = string
#}

variable "file_permission" {
    description = "The file permission for the private key file"
    type        = string
    default     = "400"
}

variable "user_data_input" {
    description = "The user data script to run on instance launch"
    type        = string
    default     = ""
}