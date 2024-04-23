output "bastion-host-sg-id" {

    description = "Bastion Host security group ID"
    value = aws_security_group.bastion-host-sg.id
  
}