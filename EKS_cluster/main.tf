
module "vpc" {
  
  source                = "./modules/vpc"
  project_name          = var.project_name 
  eks_vpc_cidr          = var.eks_vpc_cidr
  public_subnets_cidrs  = var.public_subnets_cidrs
  private_subnets_cidrs = var.private_subnets_cidrs
}

module "iam" {
  
  source           = "./modules/IAM"
  project_name     = var.project_name
  eks_cluster_name = module.eks.eks_cluster_name
  oidc-issuer      = module.eks.oidc-issuer 
}

module "eks" {
  
  source               = "./modules/EKS"
  project_name         = var.project_name
  k8s_version          = var.k8s_version 
  vpc_id               = module.vpc.vpc_id
  public_subnets_ids   = module.vpc.public_subntes_ids
  private_subnets_ids  = module.vpc.private_subnets_ids
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  ebs-csi-role-arn     = module.iam.ebs-csi-role-arn 
  node_group_id        = module.NodeGroup.node_group_id 
}

module "NodeGroup" {
  source                             = "./modules/NodeGroup"
  eks_cluster_name                   = module.eks.eks_cluster_name
  k8s_version                        = var.k8s_version 
  node_group_ami_type                = var.node_group_ami_type
  node_group_instance_type           = var.node_group_instance_type
  node_group_capacity_type           = var.node_group_capacity_type
  node_group_instances_disk_capacity = var.node_group_instances_disk_capacity
  node_group_role_arn                = module.iam.node_group_role_arn
  private_subnets_ids                = module.vpc.private_subnets_ids
}

# module "k8s-config" {
#   source           = "./modules/k8s-config"
#   project_name     = var.project_name
#   eks_cluster_name = module.eks.eks_cluster_name
#   node_group_id    = module.NodeGroup.node_group_id 
# }

