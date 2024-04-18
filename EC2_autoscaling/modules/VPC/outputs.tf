output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.pjt_vpc.id
}

output "public_subnets_ids" {
  description = "Public Subntest IDs"
  value       = aws_subnet.public_subnets.*.id
}

output "private_subnets_ids" {
  description = "Public Subntest IDs"
  value       = aws_subnet.private_subnets.*.id
}