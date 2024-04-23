resource "aws_security_group" "bastion-host-sg" {

    name   = "${var.project_name}-bastion-host"
    vpc_id = var.vpc_id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
      Name = "${var.project_name}-bastion-host"
    }
  
}

resource "aws_instance" "bastion-host" {

    ami                    = var.bastion_ami
    instance_type          = var.bastion_instance_type
    subnet_id              = element(var.public_subnets_ids, 0)
    vpc_security_group_ids = [ aws_security_group.bastion-host-sg.id ]

    key_name               = var.ssh_key_pair_name
  
}