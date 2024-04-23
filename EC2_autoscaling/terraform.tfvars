project_name = "EC2-project"

####################### VPC variables #######################

vpc_cidr              = "10.0.0.0/16"
public_subnets_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnets_cidrs = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

####################### Bastion variables #######################

bastion_ami           = "ami-01b32e912c60acdfa"
bastion_instance_type = "t2.micro"

####################### ASG variables #######################

asg_image_id                  = "ami-01b32e912c60acdfa"
asg_instance_type             = "t2.medium"
asg_block_device_name         = "/dev/xvda"
asg_block_volume_size         = 30
asg_min_size                  = 2
asg_max_size                  = 4
asg_desired_capacity          = 2
asg_health_check_type         = "ELB"
asg_health_check_grace_period = 300
