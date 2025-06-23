/*
# Jenkins Application Load Balancer (ALB) Setup Using Terraform

This script provisions:
- An Application Load Balancer (ALB) for Jenkins
- A Target Group with health checks on `/login`
- Listener rules for HTTP and HTTPS
- Target Group attachments to forward traffic to the EC2 instance
- Outputs for ALB DNS, Zone ID, and Target Group ARN
*/

# Create Target Group for Jenkins EC2
resource "aws_lb_target_group" "jenkins_lb_target_group" {
  name     = var.lb_target_group_name
  port     = var.lb_target_group_port
  protocol = var.lb_target_group_protocol
  vpc_id   = var.vpc_id

  health_check {
    path                = "/login"
    port                = 8080
    healthy_threshold   = 6
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200"
  }
}

# Attach EC2 instance to the target group
resource "aws_lb_target_group_attachment" "jenkins_target_attachment" {
  target_group_arn = aws_lb_target_group.jenkins_lb_target_group.arn
  target_id        = var.ec2_instance_id
  port             = var.lb_target_group_port
}

# Create an Application Load Balancer for Jenkins
resource "aws_lb" "jenkins_lb" {
  name                       = var.lb_name
  internal                   = var.is_external
  load_balancer_type         = var.lb_type
  security_groups            = [var.sg_enable_ssh_https]
  subnets                    = var.subnet_ids
  enable_deletion_protection = false

  tags = {
    Name = "jenkins-terraform-lb"
  }
}

# HTTPS Listener
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.jenkins_lb.arn
  port              = var.lb_https_listener_port
  protocol          = var.lb_https_listener_protocol
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
  certificate_arn   = var.terraform_jenkins_acm_arn

  default_action {
    type             = var.lb_listener_default_action
    target_group_arn = aws_lb_target_group.jenkins_lb_target_group.arn
  }
}

# HTTP Listener (optional)
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.jenkins_lb.arn
  port              = var.lb_listener_port
  protocol          = var.lb_listener_protocol

  default_action {
    type             = var.lb_listener_default_action
    target_group_arn = aws_lb_target_group.jenkins_lb_target_group.arn
  }
}

# Outputs
output "jenkins_lb_target_group_arn" {
  value = aws_lb_target_group.jenkins_lb_target_group.arn
}

output "aws_lb_dns_name" {
  value = aws_lb.jenkins_lb.dns_name
}

output "aws_lb_zone_id" {
  value = aws_lb.jenkins_lb.zone_id
}
