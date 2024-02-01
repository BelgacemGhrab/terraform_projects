variable "project_name" {
  type = string
  description = "Project name"
}
####################### VPC variables #######################
variable "eks_vpc_cidr" {
  type = string
  description = "VPC CIDR block"
}


variable "public_subnets_cidrs" {
  type        = list(string)
  description = "Public Subntes CIDR"
}

variable "private_subnets_cidrs" {
  type        = list(string)
  description = "Private Subntes CIDR"
}

####################### Node Group variables #######################

variable "node_group_instance_type" {
  type        = list(string)
  description = "node groupe instances types (default value is [t2.medium])"
}

variable "node_group_capacity_type" {
  type        = string
  description = "Capacity type of the node group (default value is ON_DEMAND)"
}

variable "node_group_ami_type" {
  type        = string
  description = "ami type of instances (default value is AL2_x86_64)"
}

variable "node_group_instances_disk_capacity" {
  type        = number
  description = "disk capacity of the instances (default value is 30)"
}

variable "node_group_desired_size" {
  type        = number
  description = "Node group desired number of instances (default value is 4)"
}

variable "node_group_max_size" {
  type        = number
  description = "Node group max number of instances (default value is 4)"
}

variable "node_group_min_size" {
  type        = number
  description = "Node group min number of instances (default value is 4)"
}

####################### k8s variables #######################

variable "k8s_version" {
  type        = string
  description = "k8s version"
}