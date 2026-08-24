variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_id" {
  type = string
}

variable "app_security_group_id" {
  type = string
}

variable "jenkins_security_group_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "ecr_repository_url" {
  type = string
}

variable "ecr_repository_arn" {
  type = string
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "desired_capacity" {
  type = number
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "jenkins_instance_type" {
  type    = string
  default = "c7i-flex.large"
}

variable "mongodb_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "database_subnet_ids" {
  type = list(string)
}

variable "database_security_group_id" {
  type = string
}