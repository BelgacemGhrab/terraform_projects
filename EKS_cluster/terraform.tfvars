project_name          = "EKS_cluster"

####################### VPC variables #######################

eks_vpc_cidr          = "10.0.0.0/16"
public_subnets_cidrs  = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
private_subnets_cidrs = [ "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24" ]

####################### Node Group variables #######################

node_group_instance_type            = [ "t2.medium" ]
node_group_capacity_type            = "ON_DEMAND"
node_group_ami_type                 = "AL2_x86_64"
node_group_instances_disk_capacity  = 30
node_group_desired_size             = 4
node_group_max_size                 = 4
node_group_min_size                 = 4

####################### k8s variables #######################

k8s_version           = "1.28"