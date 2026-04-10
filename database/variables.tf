variable "db_region_name" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "db_environment_name" {
  description = "The name of the environment (e.g., prod, qa, dev)"
  type        = string
  default     = "dev"
}

variable "allocated_storage" {
  description = "The allocated storage for the database instance"
  type        = number
  default     = 20
}

variable "db_storage_type" {
  description = "The storage type for the database instance (e.g., gp2, io1)"
  type        = string
  default     = "gp2"
}

variable "db_engine" {
  description = "The database engine to use (e.g., mysql, postgres)"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "The version of the database engine"
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "The instance class for the database instance (e.g., db.t2.micro)"
  type        = string
  default     = "db.t2.micro"
}

variable "db_username" {
  description = "The username for the database instance"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "The password for the database instance"
  type        = string
  default     = "password123"
}

variable "db_parameter_group_name" {
  description = "The name of the DB parameter group to associate with the database instance"
  type        = string
  default     = "default.mysql8.0"
}

variable "db_security_group_ids" {
  description = "A list of VPC security group IDs to associate with the database instance"
  type        = list(string)
}

variable "db_availability_zones_suffices" {
  description = "A list of suffixes for availability zones (e.g., ['a', 'b', 'c'])"
  type        = list(string)
  default     = ["a", "b"]
}

variable "db_subnet_ids" {
  description = "A list of subnet IDs for the database subnet group"
  type        = list(string)
}

variable "default_database_name" {
  description = "The name for the default database created in the RDS instance"
  type        = string
  default     = "default_db"
}