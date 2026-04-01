variable "region_name" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "aws_provider_version" {
  description = "The version of the AWS provider to use"
  type        = string
  default     = "~> 4.0"
}

variable "environment_name" {
  description = "The name of the environment"
  type        = string
  default     = "dev" 
}

variable "cidrs_for_the_ec2_instances" {
  description = "List of CIDR blocks for the EC2 instances"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "cidrs_for_the_public_subnets" {
  description = "List of CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones_suffix" {
  description = "List of availability zone suffixes for the EC2 instances"
  type        = list(string)
  default     = ["a", "b"]
}

variable "ami_image_id" {
  description = "The AMI image ID to use for the EC2 instances"
  type        = string
  default     = "ami-0c94855ba95c71c99" # Amazon Linux 2 AMI (HVM), SSD Volume Type
}

variable "instance_type" {
  description = "The instance type for the EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "all-work-stuff-dev-bucket-12345"
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

variable "ebs_volume_size_gb" {
  description = "The size of the EBS volume in GB"
  type        = number
  default     = 40
}
variable "ebs_volume_type_name" {
  description = "The type of the EBS volume"
  type        = string
  default     = "gp3"
}

variable "devices_names_for_volume_attachments" {
  description = "The device name to attach the EBS volume to the EC2 instance"
  type        = list(string)
  default     = ["/dev/sdf", "/dev/sdg"]  
}

variable "rsa_number_of_bits" {
  description = "The number of bits for the RSA key pair"
  type        = number
  default     = 4096
}

variable "file_permission" {
  description = "The file permission for the private key file"
  type        = number
  default     = 400
}