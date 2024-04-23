output "ssh_key_pair_name" {

    description = "SSH Key pair"
    value       = aws_key_pair.ec2_public_key.key_name
  
}