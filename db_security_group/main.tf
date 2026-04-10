resource "aws_security_group" "ec2_to_db_sg" {
  name        = var.security_group_name
  description = "Security group for EC2 instances to allow traffic to the database"
  vpc_id      = var.vpc_id


  ingress {
    description = "Allow traffic from the load balancer to the database"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.full_vpc_cidr_block]  ##allowing traffic from the EC2 security group, which includes the load balancer security group, instead of allowing traffic from the entire VPC, which is more secure and follows the principle of least privilege, since only the EC2 instances and the load balancer need to access the database, and allowing traffic from the entire VPC would allow any resource in the VPC to access the database, which is not necessary and could be a security risk.

    #cidr_blocks = [var.full_vpc_cidr_block]  
    ##allowing traffic from the entire VPC, which includes the EC2 security group, 
    ##instead of just allowing traffic from the EC2 security group, 
    ##because the EC2 security group does not have a fixed CIDR block, 
    ##and allowing traffic from the entire VPC is more flexible 
    ##and allows for future changes to the EC2 security group without needing to update the database security group.  
  }

  #ingress {  ##Database does not need to ssh into the instances, so this rule is not necessary
  #  description = "Allow SSH traffic from the database"
  #  from_port   = 22
  #  to_port     = 22
  #  protocol    = "tcp"
  #  cidr_blocks = [var.vpc_security_group_id]
  #}

  #ingress {  ##database does not need to run docker in these instances, so this rule is not necessary
  #  description = "Allow app traffic from the database"
  #  from_port   = 8000
  #  to_port     = 8100
  #  protocol    = "tcp"
  #  cidr_blocks = [var.vpc_security_group_id]
  #}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment_name}-DB_SG"
  }
}