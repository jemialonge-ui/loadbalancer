provider "aws" {
  region = var.region_name
  #version = var.aws_provider_version
}

module "ami_prod" {
  source              = "../../ami"
  region_name         = var.region_name
}

module "s3_prod" {
  source              = "../../s3"
  bucket_name         = var.s3_bucket_name
  region_name         = var.region_name
}

module "key_pair_prod" {
  source              = "../../keypair"
  key_name            = "${var.environment_name}_ssh_key"
  rsa_number_of_bits  = var.rsa_number_of_bits
  file_permission     = var.file_permission
  region_name         = var.region_name
}

module "vpc_prod" {
  source              = "../../vpc"
  vpc_name            = "${var.environment_name}-${var.region_name}-vpc"
  cidr_block          = var.vpc_cidr_block
  env_name            = var.region_name
  cidrs_for_public_subnets = var.cidrs_for_the_public_subnets
  region_name         = var.region_name
  availabilityzone_suffix  = var.availability_zones_suffices
  cidrs_for_private_subnets  = var.cidrs_for_the_ec2_instances  ##private_cidr_block  = "
}

module "prod_security_group" {
  source              = "../../public_security_group"
  security_group_name = "${var.environment_name}_ec2_web_sg"
  project_name        = "${var.environment_name}_project"
  vpc_id              = module.vpc_prod.vpc_id
  load_balancer_security_group_id = module.prod_alb_security_group.security_group_id
  rds_security_group_id = module.prod_db_security_group.security_group_id
}

module "prod_alb_security_group" {
  source              = "../../alb_security_group"
  security_group_name = "${var.environment_name}_alb_sg"
  project_name        = "${var.environment_name}_project"
  vpc_id              = module.vpc_prod.vpc_id
}

module "prod_db_security_group" {
  source              = "../../db_security_group"
  security_group_name = "${var.environment_name}_db_sg"
  environment_name    = "${var.environment_name}"
  vpc_id              = module.vpc_prod.vpc_id
  full_vpc_cidr_block = "${var.vpc_cidr_block}"
}

module "prod_database" { ##RDS database needs to be in a private subnet, so using the first private subnet for the database subnet group  
  source              = "../../database"
  #db_instance_name    = "${var.environment_name}-db-instance"
  allocated_storage   = var.allocated_storage_gb
  db_storage_type     = var.db_volume_storage_type
  db_engine           = var.db_engine
  db_engine_version      = var.db_engine_version
  db_instance_class      = var.db_instance_class
  db_environment_name    = var.environment_name
  #identifier             = var.db_name
  db_username            = var.db_username
  db_password         = var.db_password
  default_database_name = var.default_db_name
  db_security_group_ids = [module.prod_db_security_group.security_group_id]
  db_subnet_ids       = module.vpc_prod.Private_subnet_ids
  db_availability_zones_suffices = var.availability_zones_suffices
  db_region_name         = var.region_name 
}

module "ec2_prod1" {
  source              = "../../ec2"
  ec2_instance_name   = "${var.environment_name}-${var.region_name}-${var.availability_zones_suffices[1]}-ec2-instance"
  ami_id              = module.ami_prod.ami_id
  instance_type       = var.instance_type
  subnet_id           = module.vpc_prod.Public_subnet_ids[0]
  volume_size         = var.volume_size_gb
  volume_type         = var.volume_type_name
  #key_name            = module.key_pair_prod.key_pair_filename
  vpc_id              = module.vpc_prod.vpc_id
  security_group_ids  = [module.prod_security_group.security_group_id]
  region_name         = var.region_name
  key_name_input      = "${module.key_pair_prod.key_pairname}"
  #user_data_input = <<-EOF       ##leaving the user data commented out, so that I can know what it initially looked like before I added the database connection info to it using the templatefile function
  #                      #!/bin/bash
  #                      yum update -y
  #                      yum install -y httpd
  #                      systemctl start httpd
  #                      systemctl enable httpd
  #                      echo "Hello, World! From EC2 Prod1" > /var/www/html/index.html
  #                      systemctl restart httpd
  #                      EOF
  user_data_input     = templatefile("${path.module}/real_user_data.tftpl",
  {
    EC2_server_name = "EC2_Prod1"
    DB_ENDPOINT = module.prod_database.db_endpoint
    DB_USR = var.db_username
    DB_PASSWRD = var.db_password
    DEFAULT_DB_NAME = var.default_db_name
  }
  )

}

module "ec2_prod2" {
  source              = "../../ec2"
  ec2_instance_name   = "${var.environment_name}-${var.region_name}-${var.availability_zones_suffices[1]}-ec2-instance"
  ami_id              = module.ami_prod.ami_id
  instance_type       = var.instance_type
  subnet_id           = module.vpc_prod.Public_subnet_ids[1]
  volume_size         = var.volume_size_gb
  volume_type         = var.volume_type_name
  vpc_id              = module.vpc_prod.vpc_id
  security_group_ids  = [module.prod_security_group.security_group_id]
  region_name         = var.region_name
  key_name_input      = "${module.key_pair_prod.key_pairname}"
  user_data_input     = templatefile("${path.module}/real_user_data.tftpl",
  {
    EC2_server_name = "EC2_Prod2"
    DB_ENDPOINT = module.prod_database.db_endpoint
    DB_USR = var.db_username
    DB_PASSWRD = var.db_password
    DEFAULT_DB_NAME = var.default_db_name
  }
  )
}

module "alb_prod" {
  source                      = "../../loadbalancer"
  region_name                 = var.region_name
  security_groups_for_lb_id   = module.prod_alb_security_group.security_group_id
  ec2_dns                     = [module.ec2_prod1.webserver_public_dns, module.ec2_prod2.webserver_public_dns]
  ec2_ids                     = [module.ec2_prod1.ec2_instance_id, module.ec2_prod2.ec2_instance_id]
  subnet_ids                  = module.vpc_prod.Public_subnet_ids 
  vpc_id                      = module.vpc_prod.vpc_id
}

module "volume_prod" {
  source              = "../../ebs_volumes"
  az_suffices         = var.availability_zones_suffices
  env_name            = var.environment_name
  volume_size_gb      = var.ebs_volume_size_gb
  volume_type_name    = var.ebs_volume_type_name
  region_name         = var.region_name
  devices_names       = var.devices_names_for_volume_attachments
  EC2_instance_ids    = [module.ec2_prod1.ec2_instance_id, module.ec2_prod2.ec2_instance_id]
}
