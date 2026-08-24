variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "app_port" {
  type    = number
  default = 3000
}

variable "db_port" {
  type    = number
  default = 3306
}

variable "tags" {
  type    = map(string)
  default = {}
}