variable "project_name" {}

variable "private_subnets_ids" {
    type = set(string)
}

variable "alb_sg_id" {}

variable "vpc_id" {}

variable "alb_target_group_arn" {}

variable "bastion-host-sg-id" {}

variable "asg_image_id" {}

variable "asg_instance_type" {}

variable "asg_block_device_name" {}

variable "asg_block_volume_size" {}

variable "asg_min_size" {}

variable "asg_max_size" {}

variable "asg_desired_capacity" {}

variable "asg_health_check_type" {}

variable "asg_health_check_grace_period" {}