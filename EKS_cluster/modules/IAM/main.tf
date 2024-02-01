resource "aws_iam_role" "eks_cluster_iam_role" {
  name = "${var.project_name}-EKS-role"

  assume_role_policy = <<POLICY
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "eks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
    }
    POLICY
}

data "tls_certificate" "eks-certs" {
  url = var.oidc-issuer
}

resource "aws_iam_openid_connect_provider" "eks-oidc" {

  url = var.oidc-issuer
  
  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [data.tls_certificate.eks-certs.certificates[0].sha1_fingerprint]

  depends_on = [ var.eks_cluster_name ]
  
}


data "aws_iam_policy_document" "ebs-csi-role-doc" {

  statement {
    actions = [ "sts:AssumeRoleWithWebIdentity" ]
    effect  = "Allow" 

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks-oidc.url, "https://", "")}:aud"
      values   = [ "sts.amazonaws.com" ]
    }

    principals {
      identifiers = [ aws_iam_openid_connect_provider.eks-oidc.arn ]
      type        = "Federated"
    }
  }
  
}

resource "aws_iam_role" "ebs-csi-role" {
  assume_role_policy = data.aws_iam_policy_document.ebs-csi-role-doc.json
  name               = "${var.project_name}-ebs-csi-role"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"


  role       = aws_iam_role.eks_cluster_iam_role.name
}

resource "aws_iam_role_policy_attachment" "ELB_Fullaccess" {
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
  role       = aws_iam_role.eks_cluster_iam_role.name
}

resource "aws_iam_role" "node_group" {
  name = "${var.project_name}-node_group-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }, 
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "ebs-csi-driver_policy" {

  name = "${var.project_name}-ebs-csi-policy"

  policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Sid = "Statement1",
          Effect = "Allow",
          Action = [
            "ec2:CreateVolume",
            "ec2:DeleteVolume",
            "ec2:DetachVolume",
            "ec2:AttachVolume",
            "ec2:DescribeInstances",
            "ec2:CreateTags",
            "ec2:DeleteTags",
            "ec2:DescribeTags",
            "ec2:DescribeVolumes"
          ],
          Resource = "*"
      }]
  })
  
}

resource "aws_iam_role_policy_attachment" "worker_node" {
  

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_group.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_group.name
}

resource "aws_iam_role_policy_attachment" "ECR_read_only" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_group.name
}

resource "aws_iam_role_policy_attachment" "ebs-csi-driver" {

  policy_arn = aws_iam_policy.ebs-csi-driver_policy.arn
  role       = aws_iam_role.ebs-csi-role.name
  
}
