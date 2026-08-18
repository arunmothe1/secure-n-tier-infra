variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., prod/dev)"
  type        = string
}

variable "key_name" {
  description = "Name of the AWS Key Pair"
  type        = string
}

# Subnet Inputs
variable "public_subnet_id" {
  description = "Public subnet ID for Jenkins"
  type        = string
}

variable "app_subnet_ids" {
  description = "List of private app subnet IDs for Multi-AZ"
  type        = list(string)
}

variable "db_subnet_id" {
  description = "Private database subnet ID"
  type        = string
}

# Security Group Inputs
variable "jenkins_security_group_id" {
  description = "Security group ID for Jenkins"
  type        = string
}

variable "app_security_group_id" {
  description = "Security group ID for App instances"
  type        = string
}

variable "db_security_group_id" {
  description = "Security group ID for Database server"
  type        = string
}

# Instance Types
variable "jenkins_instance_type" {
  description = "Instance type for Jenkins"
  type        = string
}

variable "app_instance_type" {
  description = "Instance type for App servers"
  type        = string
}

variable "db_instance_type" {
  description = "Instance type for Database server"
  type        = string
}