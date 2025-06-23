variable "vpc_cidr" {
  type        = string
  description = "vpc CIDR block "
}

variable "vpc_name" {
  type        = string
  description = "vpc name"
}
variable "public_subnet_cidr" {
  type        = list(string)
  description = "public subnets cidr blocks"
}

variable "availability_zone" {
  type        = list(string)
  description = "Availabity zones"
}
