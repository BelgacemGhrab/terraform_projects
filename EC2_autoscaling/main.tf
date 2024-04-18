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
  
  source               = "./modules/EC2-ASG"
  project_name         = var.project_name
  private_subnets_ids  = module.vpc.private_subnets_ids
  alb_sg_id            = module.alb.alb_sg_id
  alb_target_group_arn = module.alb.alb_target_group_arn
  vpc_id               = module.vpc.vpc_id

}