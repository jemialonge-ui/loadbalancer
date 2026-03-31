output "security_group_name" {
    description = "The name of the security group"
    value       = "${var.security_group_name}"
}

output "security_group_id" { 
    description = "The ID of the security group"
    
    value       = aws_security_group.alb_web_sg.id
}
