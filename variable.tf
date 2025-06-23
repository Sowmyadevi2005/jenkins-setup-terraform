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
/*
variable "private_subnet_cidr" {
  type        = list(string)
  description = "private subnets cidr blocks"
}*/
variable "availability_zone" {
  type        = list(string)
  description = "Availabity zones"
}
/*
variable "public_key" {
  type = string
  description = "public key to connect to ec2 instance"
} */