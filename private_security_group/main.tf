resource "aws_security_group" "alb_to_ec2_web_sg" {
  name        = var.security_group_name
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = var.vpc_id


    ingress {
    description = "Allow HTTP traffic from the load balancer"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.load_balancer_security_group_id]
  }

  #ingress {  ##load balancer does not need to ssh into the instances, so this rule is not necessary
  #  description = "Allow SSH traffic from the load balancer"
  #  from_port   = 22
  #  to_port     = 22
  #  protocol    = "tcp"
  #  cidr_blocks = [var.load_balancer_security_group_id]
  #}

  #ingress {
  #  description = "Allow app traffic from the load balancer"
  #  from_port   = 8000
  #  to_port     = 8100
  #  protocol    = "tcp"
  #  cidr_blocks = [var.load_balancer_security_group_id]
  #}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-post_LB_SG"
  }
}