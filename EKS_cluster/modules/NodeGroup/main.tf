resource "aws_eks_node_group" "node_group" {
  cluster_name    = var.eks_cluster_name

  node_group_name = "${var.eks_cluster_name}-node_group"

  node_role_arn   = var.node_group_role_arn

  subnet_ids      = element(var.private_subnets_ids, 0)

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  ami_type             = var.node_group_ami_type 
  capacity_type        = var.node_group_capacity_type
  disk_size            = var.node_group_instances_disk_capacity
  force_update_version = false
  instance_types = var.node_group_instance_type
  labels = {
    role = "${var.eks_cluster_name}-node-group-role"
    name = "${var.eks_cluster_name}-node_group"
  }

  version = var.k8s_version

}