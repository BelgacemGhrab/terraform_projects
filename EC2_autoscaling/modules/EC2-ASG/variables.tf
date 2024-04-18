variable "project_name" {}

variable "private_subnets_ids" {
    type = set(string)
}

variable "alb_sg_id" {}

variable "vpc_id" {}

variable "alb_target_group_arn" {}