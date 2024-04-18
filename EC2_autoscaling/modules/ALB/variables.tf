variable "project_name" {}

variable "vpc_id" {}

variable "public_subnets_ids" {
    type = set(string)
}

