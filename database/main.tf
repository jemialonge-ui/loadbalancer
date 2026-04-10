provider "aws" {
  region = var.db_region_name  
}

resource "aws_db_instance" "db_instance" {
    allocated_storage    = var.allocated_storage
    storage_type         = var.db_storage_type
    engine               = var.db_engine
    engine_version       = var.db_engine_version
    instance_class       = var.db_instance_class
    identifier           = "${var.db_environment_name}-db"
    #name                 = "${var.environment_name}_db"
    username             = var.db_username
    password             = var.db_password
    parameter_group_name = var.db_parameter_group_name 
    db_name              = var.default_database_name
    db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
    skip_final_snapshot  = true
    vpc_security_group_ids = var.db_security_group_ids
    availability_zone    = "${var.db_region_name}${var.db_availability_zones_suffices[0]}"
    # Enable storage encryption
    storage_encrypted = true
    # Specify the KMS key ID for encryption (replace with your own KMS key ARN)
    kms_key_id = aws_kms_key.my_kms_key.arn
    multi_az             = false

    tags = {  
        Name = "${var.db_environment_name}_db_instance"
    }

}

resource "aws_db_subnet_group" "db_subnet_group" {
    name       = "${var.db_environment_name}-db-subnet-group"
    subnet_ids = var.db_subnet_ids

    tags = {
        Name = "${var.db_environment_name}-db-subnet-group"
    }
  
}

resource "aws_kms_key" "my_kms_key" {
    description = "KMS key for encrypting RDS storage"
    deletion_window_in_days = 10

    tags = {
        Name = "${var.db_environment_name}-rds-kms-key"
    }
}
