resource "aws_security_group" "public_web_sg" {
  name        = var.security_group_name
  description = "Allow SSH and HTTP inbound traffic to the load balancer from the internet"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP traffic from the load balancer to the instances"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [var.load_balancer_security_group_id]
  }

  ingress {   ##Allow SSH traffic from the internet to the load balancer. This rule is not necessary for the load balancer to work, but it can be useful if you want to ssh into the EC2 instances for troubleshooting or other purposes.
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {   ##For docker app traffic, if needed. This rule is not necessary for the load balancer to work, but it can be useful if you want to run docker in these instances and access the app directly without going through the load balancer.
    description = "Allow app traffic"
    from_port   = 8000
    to_port     = 8100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-public-web-to_LB_SG"
  }
}