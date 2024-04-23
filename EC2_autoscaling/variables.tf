variable "project_name" {
  type        = string
  description = "Project name"
}
####################### VPC variables #######################
variable "vpc_cidr" {
  type        = string
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

####################### Bastion variables #######################

variable "bastion_ami" {
  type        = string
  description = "Bastion Host ami"
}

variable "bastion_instance_type" {
  type        = string
  description = "Bastion Host instance type"
}

####################### ASG variables #######################

variable "asg_image_id" {
  type        = string
  description = "ASG image ID"
}

variable "asg_instance_type" {
  type        = string
  description = "ASG instance type"
}

variable "asg_block_device_name" {
  type        = string
  description = "ASG block device name"
}

variable "asg_block_volume_size" {
  type        = number
  description = "ASG block volume size"
}

variable "asg_min_size" {
  type        = number
  description = "ASG min size"
}

variable "asg_max_size" {
  type        = number
  description = "ASG max size"
}

variable "asg_desired_capacity" {
  type        = number
  description = "ASG desired capacity"
}

variable "asg_health_check_type" {
  type        = string
  description = "ASG health check type"
}

variable "asg_health_check_grace_period" {
  type        = number
  description = "ASG health check grace period"
}