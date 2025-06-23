module "networking" {
  source = "./networking"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
  public_subnet_cidr = var.public_subnet_cidr
  #private_subnet_cidr = var.private_subnet_cidr
  availability_zone = var.availability_zone
}

module "security_groups" {
  source = "./security-groups"
  vpc_id = module.networking.vpc_id
  ec2_sg_name         = "SG for EC2 to enable SSH(22), HTTPS(443) and HTTP(80)"
  ec2_jenkins_sg_name = "Allow port 8080 for jenkins"
}

module "jenkins" {
  source = "./jenkins"
  ami_id = "ami-020cba7c55df1f615"
  instance_type = "t2.medium"
  tag_name = "Jenkins:Ubuntu Linux EC2"
  public_key = file("${path.module}/keys/id_rsa.pub")
  subnet_id = tolist(module.networking.public_subnets)[0]
  sg_for_jenkins = [module.security_groups.jenkins_sg, module.security_groups.ec2_public_sg]
  enable_public_ip_address = true
  user_data_install_jenkins = templatefile("./jenkins-runner-script/jenkins-installer.sh", {})
}


module "alb" {
  source                    = "./load-balancer"
  lb_target_group_name = "jenkins-lb-target-group"
  lb_target_group_port = 8080
  lb_https_listener_protocol = "HTTPS"
  lb_target_group_protocol ="HTTP"
  vpc_id = module.networking.vpc_id
  ec2_instance_id = module.jenkins.jenkins_ec2_instance_ip
  lb_name = "jenkins-lb-terraform"
  is_external = false
  lb_type = "application"
  sg_enable_ssh_https = module.security_groups.ec2_public_sg
  subnet_ids = tolist(module.networking.public_subnets)
 lb_listener_port           = 80
  lb_listener_protocol       = "HTTP"
  lb_listener_default_action = "forward"
  lb_https_listener_port     = 443
  terraform_jenkins_acm_arn=module.aws_ceritification_manager.domain_acm_arn
  

}

module "hosted_zone" {
  source          = "./hosted_zone"
  domain_name     = "jenkins.builddeployscale.xyz"
  aws_lb_dns_name = module.alb.aws_lb_dns_name
  aws_lb_zone_id  = module.alb.aws_lb_zone_id
}

module "aws_ceritification_manager" {
  source         = "./certificate-manager"
  domain_name    = "jenkins.builddeployscale.xyz"
  hosted_zone_id = module.hosted_zone.hosted_zone_id
}