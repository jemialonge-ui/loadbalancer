provider "aws" {
  region = var.region_name
}

resource "tls_private_key" "RSA_key_setup" {
  algorithm = "RSA"
  rsa_bits  = var.rsa_number_of_bits
}

resource "aws_key_pair" "my_key_pair" {
    key_name = var.key_name
    public_key = tls_private_key.RSA_key_setup.public_key_openssh
}

resource "local_file" "ssh_private_key_as_pem" {
    content = tls_private_key.RSA_key_setup.private_key_pem
    filename = "${aws_key_pair.my_key_pair.key_name}.pem"
    file_permission = var.file_permission
}