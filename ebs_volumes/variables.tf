variable "region_name" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "env_name" {
  description = "The name of the environment"
  type        = string
  default     = "dev"
}

variable "volume_size_gb" {
  description = "The size of the EBS volume in GB"
  type        = number
  default     = 30
}

variable "volume_type_name" {
  description = "The type of the EBS volume"
  type        = string
  default     = "gp2"
}

variable "az_suffices" {
  description = "The availability zone to deploy the EBS volume in"
  type        = list(string)
  default     = ["a"]  
}

variable "devices_names" {
  description = "The device name to attach the EBS volume to the EC2 instance"
  type        = list(string)
  default     = ["/dev/sdf"]  
}

variable "EC2_instance_ids" {
  description = "The IDs of the EC2 instances to attach the EBS volumes to"
  type        = list(string)
}