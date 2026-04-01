output "ip_addr" {
    description = "The public IP address of the EC2 instance"
    value       = aws_instance.ec2_instance.public_ip
}

output "EC2-name" {
    description = "The name of the EC2 instance"
    value      = aws_instance.ec2_instance.tags["Name"]
}

output "ssh_command" {
    description = "The command to run to ssh into the server"
    value       = "ssh -i ${var.key_name_input}.pem ec2-user@${aws_instance.ec2_instance.public_dns}"
}

output "webserver_public_dns" {
    description = "The public DNS of the EC2 instance"
    value       = aws_instance.ec2_instance.public_dns
}

output "ec2_instance_id" {
    description = "The ID of the EC2 instance"
    value       = aws_instance.ec2_instance.id
}

output "av_zone" {
    description = "The availability zone of the EC2 instance"
    value       = aws_instance.ec2_instance.availability_zone
}