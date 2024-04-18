resource "aws_security_group" "ec2_sg" {

    name = "ec2-sg"
    vpc_id = var.vpc_id
    ingress {
        security_groups = [ var.alb_sg_id ]
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
        Name = "${var.project_name} EC2 security group"
    }
  
}

resource "tls_private_key" "ec2_private_key" {
  
  algorithm = "RSA"
  rsa_bits  = "4096" 
}

resource "aws_key_pair" "ec2_key_pair" {
  
  key_name   = "ssh-key-pair"
  public_key = tls_private_key.ec2_private_key.private_key_openssh

}

resource "local_file" "ec2_ssh_key" {

  content              = tls_private_key.ec2_private_key.private_key_pem
  filename             = "ssh-key-pair.pem"
  directory_permission = 0600 
  
}

resource "aws_launch_template" "as_launch_template" {
  
  name                   = "${var.project_name}-as-launch-template"

  image_id               = "ami-01b32e912c60acdfa"
  instance_type          = "t2.medium"
  user_data              = filebase64("install_script.sh")
  vpc_security_group_ids = [ aws_security_group.ec2_sg.id ]
  key_name               = aws_key_pair.ec2_key_pair.key_name 

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 30
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.project_name} autoscaling group launch template"
  }
}

resource "aws_autoscaling_group" "asg" {
    name                      = "asg"
    min_size                  = 2
    max_size                  = 4
    desired_capacity          = 2
    health_check_grace_period = 300
    health_check_type         = "ELB"
    vpc_zone_identifier       = var.private_subnets_ids

    launch_template {
      id      = aws_launch_template.as_launch_template.id
      version = "$Latest"
    }
  
}

resource "aws_autoscaling_policy" "asg_policy" {

    name = "asg-policy-cpu"
    policy_type = "TargetTrackingScaling"
    autoscaling_group_name = aws_autoscaling_group.asg.name
    target_tracking_configuration {
      predefined_metric_specification {
        predefined_metric_type = "ASGAverageCPUUtilization"
      }
      target_value = 50.0
    } 
}

resource "aws_autoscaling_attachment" "asg_attachment" {

    autoscaling_group_name = aws_autoscaling_group.asg.name
    lb_target_group_arn    = var.alb_target_group_arn
  
}