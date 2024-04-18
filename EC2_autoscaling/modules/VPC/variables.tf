variable "project_name" {}

variable "vpc_cidr" {
  description = "new EKS VPC"
  default     = "10.0.0.0/16"
  type        = string
}

variable "public_subnets_cidrs" {
  type        = list(string)
  description = "Public Subntes CIDR"
  default     = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
}

variable "private_subnets_cidrs" {
  type        = list(string)
  description = "Private Subntes CIDR"
  default     = [ "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24" ]
}