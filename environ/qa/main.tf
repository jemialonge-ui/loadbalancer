provider "aws" {
  region = var.region_name
  #version = var.aws_provider_version
}

module "s3_qa" {
  source              = "../../s3"
  bucket_name         = var.s3_bucket_name
  region_name         = var.region_name
}

module "key_pair_qa" {
  source              = "../../keypair"
  key_name            = "${var.environment_name}_ssh_key"
  rsa_number_of_bits  = var.rsa_number_of_bits
  file_permission     = var.file_permission
  region_name         = var.region_name
}

module "vpc_qa" {
  source              = "../../vpc"
  vpc_name            = "${var.environment_name}-${var.region_name}-vpc"
  env_name            = var.region_name
  cidrs_for_public_subnets = var.cidrs_for_the_public_subnets
  region_name         = var.region_name
  availabilityzone_suffix  = var.availability_zones_suffix
  cidrs_for_private_subnets  = var.cidrs_for_the_ec2_instances  ##private_cidr_block  = "
}

module "qa_security_group" {
  source              = "../../public_security_group"
  security_group_name = "${var.environment_name}_ec2_web_sg"
  project_name        = "${var.environment_name}_project"
  vpc_id              = module.vpc_qa.vpc_id
  load_balancer_security_group_id = module.qa_alb_security_group.security_group_id
}

module "qa_alb_security_group" {
  source              = "../../alb_security_group"
  security_group_name = "${var.environment_name}_alb_sg"
  project_name        = "${var.environment_name}_project"
  vpc_id              = module.vpc_qa.vpc_id
}

module "ec2_qa1" {
  source              = "../../ec2"
  ec2_instance_name   = "${var.environment_name}-${var.region_name}-${var.availability_zones_suffix[1]}-ec2-instance"
  ami_id              = var.ami_image_id
  instance_type       = var.instance_type
  subnet_id           = module.vpc_qa.Public_subnet_ids[0]
  volume_size         = var.volume_size_gb
  volume_type         = var.volume_type_name
  vpc_id              = module.vpc_qa.vpc_id
  security_group_ids  = [module.qa_security_group.security_group_id]
  region_name         = var.region_name
  key_name_input      = "${module.key_pair_qa.key_pairname}"
  user_data_input = <<-EOF
                        #!/bin/bash
                        yum update -y
                        yum install -y httpd
                        systemctl start httpd
                        systemctl enable httpd
                        echo "Hello, World! From EC2 Dev1" > /var/www/html/index.html
                        systemctl restart httpd
                        EOF
}

module "ec2_qa2" {
  source              = "../../ec2"
  ec2_instance_name   = "${var.environment_name}-${var.region_name}-${var.availability_zones_suffix[1]}-ec2-instance"
  ami_id              = var.ami_image_id
  instance_type       = var.instance_type
  subnet_id           = module.vpc_qa.Public_subnet_ids[1]
  volume_size         = var.volume_size_gb
  volume_type         = var.volume_type_name
  vpc_id              = module.vpc_qa.vpc_id
  security_group_ids  = [module.qa_security_group.security_group_id]
  region_name         = var.region_name
  key_name_input      = "${module.key_pair_qa.key_pairname}"
  user_data_input     = <<-EOF
                        #!/bin/bash
                        yum update -y
                        yum install -y httpd
                        systemctl start httpd
                        systemctl enable httpd
                        echo "Hello, World! From EC2 QA2" > /var/www/html/index.html
                        systemctl restart httpd
                        EOF
}

module "alb_qa" {
  source                      = "../../loadbalancer"
  region_name                 = var.region_name
  security_groups_for_lb_id   = module.qa_alb_security_group.security_group_id
  ec2_dns                     = [module.ec2_qa1.webserver_public_dns, module.ec2_qa2.webserver_public_dns]
  ec2_ids                     = [module.ec2_qa1.ec2_instance_id, module.ec2_qa2.ec2_instance_id]
  subnet_ids                  = module.vpc_qa.Public_subnet_ids 
  vpc_id                      = module.vpc_qa.vpc_id
}

module "volume_qa" {
  source              = "../../ebs_volumes"
  az_suffices         = var.availability_zones_suffix
  env_name            = var.environment_name
  volume_size_gb      = var.ebs_volume_size_gb
  volume_type_name    = var.ebs_volume_type_name
  region_name         = var.region_name
  devices_names       = var.devices_names_for_volume_attachments
  EC2_instance_ids    = [module.ec2_qa1.ec2_instance_id, module.ec2_qa2.ec2_instance_id]
}
