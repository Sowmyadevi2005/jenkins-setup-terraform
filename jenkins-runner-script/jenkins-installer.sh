#!/bin/bash

# Script to automate the installation of Jenkins and Terraform on a Debian/Ubuntu-based system.
# 
# What it does:
# - Installs OpenJDK 11 (required for Jenkins)
# - Adds Jenkins GPG key and repository, then installs Jenkins
# - Waits briefly to ensure services are ready before each major install step
# - Downloads and installs Terraform version 1.6.5
#
# This script is intended to be used as a user-data script during EC2 instance launch or for manual provisioning.


# Update package lists
sudo apt-get update

# Install OpenJDK 17 instead of JDK 11
yes | sudo apt install openjdk-17-jdk-headless

# Wait before installing Jenkins
echo "Waiting for 30 seconds before installing the Jenkins package..."
sleep 30

# Add Jenkins GPG key and repo
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update packages again after adding Jenkins repo
sudo apt-get update

# Install Jenkins
yes | sudo apt-get install jenkins

# Wait before installing Terraform
echo "Waiting for 30 seconds before installing Terraform..."
sleep 30

# Install Terraform
wget https://releases.hashicorp.com/terraform/1.6.5/terraform_1.6.5_linux_386.zip
yes | sudo apt-get install unzip
unzip terraform_1.6.5_linux_386.zip
sudo mv terraform /usr/local/bin/