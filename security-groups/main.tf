/*
# AWS Security Groups for EC2 and Jenkins

This Terraform configuration defines two AWS security groups:

1. **ec2_public_access_sg** – Allows inbound SSH (port 22) and HTTP (port 80) access from anywhere.
2. **jenkins_ec2_sg** – Allows inbound access to port 8080 for Jenkins web UI.

These security groups are associated with the specified VPC and can be attached to EC2 instances accordingly.

## Outputs:
- `ec2_public_sg`: Security group ID for public EC2 access
- `jenkins_sg`: Security group resource for Jenkins instance
*/

#==============================
# Variables
#==============================
variable "ec2_sg_name" {}
variable "vpc_id" {}
variable "ec2_jenkins_sg_name" {}

#==============================
# Resources
#==============================

# Security Group to allow public access (SSH & HTTP) to EC2 instances
resource "aws_security_group" "ec2_public_access_sg" {
  name        = "SG for EC2 to enable SSH(22), HTTPS(443) and HTTP(80)"
  description = "Enable the Port 22(SSH) & Port 80(HTTP)"
  vpc_id      = var.vpc_id

  # Inbound rule to allow SSH (port 22) from anywhere
  ingress {
    description = "Allow remote SSH from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  # Inbound rule to allow HTTP (port 80) from anywhere
  ingress {
    description = "Allow HTTP request from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  # Outbound rule to allow all traffic from EC2 to outside
  egress {
    description = "Allow outgoing request"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "Security Group to allow SSH(22) and HTTP(80)"
  }
}

# Security Group to allow access to Jenkins Web UI (port 8080)
resource "aws_security_group" "jenkins_ec2_sg" {
  name        = "Allow port 8080 for jenkins"
  description = "Enable the Port 8080 for Jenkins"
  vpc_id      = var.vpc_id

  # Inbound rule to allow port 8080 (Jenkins)
  ingress {
    description = "Allow 8080 port to access Jenkins"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
  }

  tags = {
    "Name" = "Security Group to allow Jenkins (8080)"
  }
}


#==============================
# Output: 
#==============================
# Output the security group ID for EC2 public access
output "ec2_public_sg" {
  value = aws_security_group.ec2_public_access_sg.id
}

# Output the full security group resource for Jenkins
output "jenkins_sg" {
  value = aws_security_group.jenkins_ec2_sg.id
}
