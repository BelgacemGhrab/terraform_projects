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