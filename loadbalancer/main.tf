provider "aws" {
    region = var.region_name
}

resource "aws_lb" "app_lb" {
    name = "my-load-balancer"
    internal = false
    ip_address_type = "ipv4"
    load_balancer_type = "application"
    security_groups = [var.security_groups_for_lb_id] ##public security group id
    subnets = var.subnet_ids  ##subnet ids for the load balancer public subnets

    tags = {
      Name = "alb"
    }
}

resource "aws_lb_target_group" "app_lb_target_group" {
    name = "my-target-group"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc_id

    health_check {
        enabled             = true
        healthy_threshold   = 3
        interval            = 10
        matcher             = 200
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 6
        unhealthy_threshold = 3
    }    

    tags = {
      Name = "alb_ec2_tg"
    }
}

# Attach the target group to the AWS instances
resource "aws_lb_target_group_attachment" "attach-app" {
  count            = length(var.ec2_ids)
  target_group_arn = aws_lb_target_group.app_lb_target_group.arn
  target_id        = element(var.ec2_ids, count.index)
  port             = 80
}


resource "aws_lb_listener" "app_lb_listener" {
    load_balancer_arn = aws_lb.app_lb.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.app_lb_target_group.arn
    }
}

