# Jenkins Setup on AWS using Terraform

This repository contains Terraform scripts to provision a complete Jenkins setup on AWS, including the network infrastructure and a Jenkins-ready EC2 instance.

## 📦 What This Project Does

Using Terraform, the following AWS resources are created:

- ✅ **VPC** with public subnet(s)
- ✅ **Internet Gateway** and **Route Tables**
- ✅ **Security Group** with access for Jenkins (port 8080) and SSH (port 22)
- ✅ **Public Hosted Zone** in Route 53 (optional for domain mapping)
- ✅ **EC2 Instance** with:
  - Jenkins installed and running
  - Terraform CLI installed
- ✅ **Application Load Balancer (ALB)** for high availability

## 📁 Folder Structure

```
.
jenkins-setup-terraform/
├── certificate-manager/           # ACM (SSL/TLS) related configuration
├── hosted_zone/                   # Route53 hosted zone setup
├── jenkins/                       # Jenkins EC2 instance and provisioning
├── jenkins-runner-script/         # Jenkins setup shell/user-data scripts
├── keys/                          # SSH keys (DO NOT COMMIT private keys)
├── load-balancer/                 # AWS ALB definitions
├── networking/                    # VPC, subnets, IGW, route tables
├── security-groups/               # Security group rules
├── .gitignore                     # Git ignore rules
├── main.tf                        # Main Terraform config entry
├── outputs.tf                     # Output definitions (optional, if exists)
├── provider.tf                    # AWS provider and backend config
└── variable.tf                    # Input variable definitions
```

## 🚀 How to Deploy

1. **Clone the repo**
   ```bash
   git clone https://github.com/Sowmyadevi2005/jenkins-setup-terraform.git
   cd jenkins-setup-terraform
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Validate and Apply the Configuration**
   ```bash
   terraform plan --var-file="terraform.tfvars"  #tfvars file should be with variable values
   terraform apply --var-file="terraform.tfvars" --auto-approve
   ```

4. **Access Jenkins**
   - Use the output public DNS or Load Balancer DNS
   - Default port: `8080`

## ⚙️ Prerequisites

- AWS account and IAM credentials
- Terraform installed (`>= 1.0.0`)
- Key pair available for EC2 access

## 📌 Notes

- Ensure your AWS region is set correctly in `provider` block or `terraform.tfvars`.
- Jenkins is installed using a user data script during EC2 instance launch.
- You can optionally attach a Route53 domain for custom access.

## 📜 License

This project is open-source and available under the [MIT License](LICENSE).

---

Feel free to fork, contribute, or raise issues. Happy DevOpsing! 🚀
