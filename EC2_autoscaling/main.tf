module "vpc" {

  source                = "./modules/VPC"
  project_name          = var.project_name
  vpc_cidr              = var.vpc_cidr
  public_subnets_cidrs  = var.public_subnets_cidrs
  private_subnets_cidrs = var.private_subnets_cidrs

}

module "alb" {

  source             = "./modules/ALB"
  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  public_subnets_ids = module.vpc.public_subnets_ids
}

module "ec2-autoscaling" {
  
  source                        = "./modules/EC2-ASG"
  project_name                  = var.project_name
  private_subnets_ids           = module.vpc.private_subnets_ids
  alb_sg_id                     = module.alb.alb_sg_id
  alb_target_group_arn          = module.alb.alb_target_group_arn
  vpc_id                        = module.vpc.vpc_id
  bastion-host-sg-id            = module.bastion-host.bastion-host-sg-id 
  asg_image_id                  = var.asg_image_id
  asg_instance_type             = var.asg_instance_type
  asg_block_device_name         = var.asg_block_device_name 
  asg_block_volume_size         = var.asg_block_volume_size
  asg_min_size                  = var.asg_min_size
  asg_max_size                  = var.asg_max_size
  asg_desired_capacity          = var.asg_desired_capacity
  asg_health_check_grace_period = var.asg_health_check_grace_period
  asg_health_check_type         = var.asg_health_check_type

}

module "bastion-host" {
  
  source                = "./modules/BASTION-HOST"
  project_name          = var.project_name
  public_subnets_ids    = module.vpc.public_subnets_ids
  ssh_key_pair_name     = module.ec2-autoscaling.ssh_key_pair_name
  vpc_id                = module.vpc.vpc_id
  bastion_ami           = var.bastion_ami
  bastion_instance_type = var.bastion_instance_type

}