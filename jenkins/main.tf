/*
# Jenkins EC2 Instance Provisioning on AWS using Terraform
This configuration provisions:
- An EC2 instance to host Jenkins
- A key pair for SSH access
- A public IP and SGs for remote access
- User data to install Jenkins and Terraform
## Outputs:
- Public IP of the instance
  - The EC2 instance's **public IP address**
- Ready-to-use SSH connection string
  - A ready-to-use **SSH connection string** for accessing the Jenkins instance
*/

# Create an EC2 instance for Jenkins setup
resource "aws_instance" "jenkins_ec2_instance" {
  ami                         = var.ami_id                              # AMI to use for EC2
  instance_type               = var.instance_type                       # e.g., t2.micro
  key_name                    = aws_key_pair.jenkins_ec2_instance_public_key.key_name    # Name of the key pair
  subnet_id                   = var.subnet_id                           # Subnet to launch the instance in
  vpc_security_group_ids      = var.sg_for_jenkins                      # Attach security group(s)
  associate_public_ip_address = var.enable_public_ip_address            # Enable public IP if true
  user_data                   = var.user_data_install_jenkins           # Script to install Jenkins

  # Enable and enforce the use of Instance Metadata Service v2
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    "Name" = var.tag_name   # Tag for the EC2 instance
  }
}

# Create an AWS key pair for SSH access using a provided public key
resource "aws_key_pair" "jenkins_ec2_instance_public_key" {
  key_name   = "aws_ec2_terraform"      # Name shown in AWS Console
  public_key = var.public_key           # The actual public key content (from .pub file)
}

# Output the public IP of the EC2 instance (fixed to match the name)
output "jenkins_ec2_instance_public_ip" {
  value = aws_instance.jenkins_ec2_instance.public_ip
}

# Output a ready-to-use SSH command string for connecting to the EC2 instance
output "ssh_connection_string_for_ec2" {
  value = format(
    "ssh -i /Users/Sowmya/.ssh/aws_ec2_terraform ubuntu@%s",
    aws_instance.jenkins_ec2_instance.public_ip
  )
}
# Output of the EC2 instance id
output "jenkins_ec2_instance_ip" {
  value = aws_instance.jenkins_ec2_instance.id
}