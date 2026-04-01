provider "aws" {
    region = var.region_name
}

resource "aws_instance" "ec2_instance" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name_input
    subnet_id = var.subnet_id
    #vpc_id = var.vpc_id
    security_groups = var.security_group_ids
    user_data = var.user_data_input

    root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
        tags = {
            Name = "root_volume_of_${var.ec2_instance_name}"
        }
    }
    
    tags = {
        Name = "${var.ec2_instance_name}"
        }
}

 