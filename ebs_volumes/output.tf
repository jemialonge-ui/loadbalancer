output "ebs_details" {
    description = "The details of the EBS volume such as volume name, volumeID, availability zone, size, and type"
    value = [for volume in aws_ebs_volume.volume_here : {
            volume_name = volume.tags["Name"]
            volume_id = volume.id
            availability_zone = volume.availability_zone
            size_gb = volume.size
            type = volume.type
            instance_id = aws_volume_attachment.attach_here[0].instance_id
        }
    ]
}
