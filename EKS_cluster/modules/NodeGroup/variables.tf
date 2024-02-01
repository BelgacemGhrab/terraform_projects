variable "eks_cluster_name" {}

variable "k8s_version" {}

variable "node_group_role_arn" {}

variable "private_subnets_ids" {}

variable "node_group_instance_type" {
  type        = list(string)
  description = "node groupe instances types"  
  default     = [ "t2.medium" ]
}

variable "node_group_capacity_type" {
  type        = string
  description = "Capacity type of the node group"
  default     = "ON_DEMAND"
}

variable "node_group_ami_type" {
  type        = string
  description = "ami type of instances"
  default     = "AL2_x86_64"
}

variable "node_group_instances_disk_capacity" {
  type        = number
  description = "disk capacity of the instances"
  default     = 30
}

variable "node_group_desired_size" {
  type        = number
  description = "Node group desired number of instances"
  default     = 4
}

variable "node_group_max_size" {
  type        = number
  description = "Node group max number of instances"
  default     = 4
}

variable "node_group_min_size" {
  type        = number
  description = "Node group min number of instances"
  default     = 4
}