provider "aws" {
    region = var.region_name  
}

data "aws_ami" "base_ami" {
    most_recent = true
    filter {
        name   = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["amazon"]
}

resource "aws_ami_copy" "my_ami" {
    name              = "my-ami-copy"
    description       = "A copy of the base AMI"
    source_ami_id     = data.aws_ami.base_ami.id
    source_ami_region = var.region_name  
}

