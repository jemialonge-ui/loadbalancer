variable "key_name" {
    description = "The name of the key pair"
    type        = string
}

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

variable "region_name" {
    description = "The AWS region name"
    type        = string
    default     = "us-east-1"
}