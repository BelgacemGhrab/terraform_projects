resource "aws_eks_cluster" "eks_cluster" {
  
  name = var.project_name

  role_arn = var.eks_cluster_role_arn

  version = var.k8s_version

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access = true
    subnet_ids = concat(element(var.public_subnets_ids, 0), element(var.private_subnets_ids, 0))
  }

}

resource "aws_eks_addon" "ebs-csi-driver" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "aws-ebs-csi-driver"
  service_account_role_arn = var.ebs-csi-role-arn

  depends_on = [ var.node_group_id ]
}

