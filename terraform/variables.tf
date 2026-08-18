variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "ap-south-1"
}

variable "key_name" {
  type    = string
  default = "my-aws-key" # your AWS Key Pair  exact name
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public Subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_app_subnet_cidr" {
  description = "Private App Subnet CIDR"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_db_subnet_cidr" {
  description = "Private Database Subnet CIDR"
  type        = string
  default     = "10.0.3.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "secure-aws-devops"
}

variable "jenkins_instance_type" {
  description = "Instance type for Jenkins Controller"
  type        = string
  default     = "t3.small"
}

variable "app_instance_type" {
  description = "Instance type for Application Servers"
  type        = string
  default     = "t3.micro"
}

variable "db_instance_type" {
  description = "Instance type for Database Server"
  type        = string
  default     = "t3.micro"
}

variable "application_port" {
  description = "Port on which the application listens"
  type        = number
  default     = 80
}

variable "database_port" {
  description = "Port on which MongoDB listens"
  type        = number
  default     = 27017
}