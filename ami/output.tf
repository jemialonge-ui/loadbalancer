output "ami_id" {
    value = aws_ami_copy.my_ami.id
    description = "The ID of the copied AMI"
}