variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "alb_security_group_id" {
  type = string
}

variable "app_instance_ids" {
  type = list(string)
}

variable "application_port" {
  type = number
}

variable "environment" {
  type = string
}