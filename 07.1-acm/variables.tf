variable "project_name" {
  default = "expense"
}

variable "environment" {
  type = string
  default = "dev"
}

variable "common_tags" {
  default = {
    Project = "expense"
    Environment = "dev"
    Terraform = "true"
    Component = "app-alb"
  }
}

variable "zone_name" {
  default = "devopskk.online"
}

variable "zone_id" {
  default = "Z08884492QFPW45HM4UQO"
}