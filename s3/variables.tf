variable "region_name" {
  description = "Region where you want to set up the S3 bucket"
  default = "us-east-1"
  type = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket to be created"
  type = string
}