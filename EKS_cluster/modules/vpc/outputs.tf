output "vpc_id" {
  value = aws_vpc.eks_vpc.id
}

output "igw_id" {
  value = aws_internet_gateway.eks_igw
}

output "public_subntes_ids" {
  value = ["${aws_subnet.public_subnets.*.id}"]
}

output "private_subnets_ids" {
  value = ["${aws_subnet.private_subnets.*.id}"]
}