variable "region" {
  type = string
  description = "The AWS region."
}

variable "environment" {
  type = string
  description = "The name of our environment, i.e. development."
  default = "development"
}

variable "key_name" {
  type = string
  description = "The AWS key pair to use for resources."
  default = "development"
}

variable "vpc_cidr" {
  type = string
  description = "The CIDR of the VPC."
}

variable "public_subnets" {
  description = "The list of public subnets to populate."
}

variable "private_subnets" {
  description = "The list of private subnets to populate."
}
variable "private02_subnets" {
  description = "The list of private subnets to populate."
}

variable "map_public_ip_on_launch" {
  type = bool
  description = "Should be false if you do not want to auto-assign public IP on launch"
  default     = true
}
