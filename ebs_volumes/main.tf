provider "aws" {
    region = var.region_name
}

resource "aws_ebs_volume" "volume_here" {
    count             = length(var.az_suffices)
    availability_zone = "${var.region_name}${var.az_suffices[count.index]}"  ## i need to fix this
    size              = var.volume_size_gb
    type              = var.volume_type_name

    tags = {
        Name = "${var.env_name}-${var.region_name}${var.az_suffices[count.index]}-${count.index}-ebs-volume"
        Environment = var.env_name
        AZ = "${var.region_name}${var.az_suffices[count.index]}"
        region = var.region_name
    } 
}

#resource "aws_volume_attachment" "attach_here" { 
#    count = length(var.az_suffices)
#    device_name = "${var.device_name}"
#    volume_id   = aws_ebs_volume.volume_here[count.index].id
#    instance_id = var.EC2_instance_ids[count.index]
#    force_detach = true 
#}

resource "aws_volume_attachment" "attach_here" { 
    count = length(var.az_suffices)
    device_name = "${var.devices_names[count.index]}"
    volume_id   = aws_ebs_volume.volume_here[count.index].id
    instance_id = var.EC2_instance_ids[count.index]
    force_detach = true 
}