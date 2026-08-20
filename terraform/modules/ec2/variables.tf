variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "key_name" {
  type = string
}

variable "jenkins_instance_type" {
  type = string
}

variable "app_instance_type" {
  type = string
}

variable "db_instance_type" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "app_subnet_id" {
  type = string
}

variable "db_subnet_id" {
  type = string
}

variable "jenkins_security_group_id" {
  type = string
}

variable "app_security_group_id" {
  type = string
}

variable "db_security_group_id" {
  type = string
}