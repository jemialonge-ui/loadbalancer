provider "aws" {
  region = var.region_name
}

module "s3_prod" {
  source              = "../../s3"
  bucket_name         = var.s3_bucket_name
  region_name         = var.region_name

  #tags = {
  #  Environment = "Development"
  #}
}

module "key_pair_prod" {
  source              = "../../keypair"
  key_name            = "${var.environment_name}_ssh_key"
  rsa_number_of_bits  = 4096
  file_permission     = 400
#  filename            = "dev_ssh_key.pem"
  region_name         = var.region_name
}

module "vpc_prod" {
  source              = "../../vpc"
  vpc_name            = "${var.environment_name}-vpc"
  env_name            = var.region_name
  #cidr_block          = "10.0.0.0/16"
  cidrs_for_public_subnets = var.cidrs_for_the_public_subnets
  region_name         = "us-east-1"
  availabilityzone_suffix  = var.availability_zones_suffix
  #public_cidr_block1  = "10.0.1.0/24"
  #public_cidr_block2  = "10.0.2.0/24"
  cidrs_for_private_subnets  = var.cidrs_for_the_ec2_instances  ##private_cidr_block  = "
  #depends_on          = [module.key_pair_${var.environment_name}]
}

module "prod_security_group" {
  source              = "../../public_security_group"
  security_group_name = "${var.environment_name}_ec2_web_sg"
  project_name        = "${var.environment_name}_project"
  vpc_id              = module.vpc_prod.vpc_id
  load_balancer_security_group_id = module.prod_alb_security_group.security_group_id
  #depends_on          = [module.vpc_prod]
}

module "prod_alb_security_group" {
  source              = "../../alb_security_group"
  security_group_name = "${var.environment_name}_alb_sg"
  project_name        = "${var.environment_name}_project"
  vpc_id              = module.vpc_prod.vpc_id
  #load_balancer_security_group_id = module.prod_security_group.security_group_id
  #depends_on          = [module.vpc_prod]
}

module "ec2_prod1" {
  source              = "../../ec2"
  ec2_instance_name   = "${var.environment_name}-ec2-instance"
  ami_id              = var.ami_image_id
  instance_type       = var.instance_type
  subnet_id           = module.vpc_prod.Public_subnet_ids[0]
  volume_size         = var.volume_size_gb
  volume_type         = var.volume_type_name
  #key_name            = module.key_pair_prod.key_pair_filename
  vpc_id              = module.vpc_prod.vpc_id
  security_group_ids  = [module.prod_security_group.security_group_id]
  region_name         = var.region_name
  key_name_input      = "${module.key_pair_prod.key_pairname}"
  rsa_number_of_bits  = 4096
  file_permission     = 400
  user_data_input = <<-EOF
                        #!/bin/bash
                        yum update -y
                        yum install -y httpd
                        systemctl start httpd
                        systemctl enable httpd
                        echo "Hello, World! From EC2 Prod1" > /var/www/html/index.html
                        systemctl restart httpd
                        EOF
  #depends_on          = [module.vpc_prod]
}

module "ec2_prod2" {
  source              = "../../ec2"
  ec2_instance_name   = "${var.environment_name}-ec2-instance"
  ami_id              = var.ami_image_id
  instance_type       = var.instance_type
  subnet_id           = module.vpc_prod.Public_subnet_ids[1]
  volume_size         = var.volume_size_gb
  volume_type         = var.volume_type_name
  #key_name            = module.key_pair_prod.key_pair_filename
  vpc_id              = module.vpc_prod.vpc_id
  security_group_ids  = [module.prod_security_group.security_group_id]
  region_name         = var.region_name
  key_name_input      = "${module.key_pair_prod.key_pairname}"
  rsa_number_of_bits  = 4096
  file_permission     = 400
  user_data_input     = <<-EOF
                        #!/bin/bash
                        yum update -y
                        yum install -y httpd
                        systemctl start httpd
                        systemctl enable httpd
                        echo "Hello, World! From EC2 Prod2" > /var/www/html/index.html
                        systemctl restart httpd
                        EOF
  #depends_on          = [module.vpc_prod]
}

module "alb_prod" {
  source                      = "../../loadbalancer"
  region_name                 = var.region_name
  security_groups_for_lb_id   = module.prod_alb_security_group.security_group_id
  ec2_dns                     = [module.ec2_prod1.webserver_public_dns, module.ec2_prod2.webserver_public_dns]
  ec2_ids                     = [module.ec2_prod1.ec2_instance_id, module.ec2_prod2.ec2_instance_id]
  subnet_ids                  = module.vpc_prod.Public_subnet_ids 
  vpc_id                      = module.vpc_prod.vpc_id

  #depends_on                  = [module.prod_alb_security_group, module.vpc_prod]
}

