resource "aws_security_group" "alb_web_sg" {
  name        = var.security_group_name
  description = "Allow SSH and HTTP inbound traffic to the load balancer from the internet"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP traffic to the load balancer from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #security_groups = [var.load_balancer_security_group_id]
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