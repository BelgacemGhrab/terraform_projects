resource "aws_vpc" "pjt_vpc" {

    cidr_block                       = var.vpc_cidr
    enable_dns_hostnames             = true
    enable_dns_support               = true
    assign_generated_ipv6_cidr_block = false

    tags = {
      Name = var.project_name
    }
  
}

resource "aws_internet_gateway" "igw" {

    vpc_id = aws_vpc.pjt_vpc.id

    tags = {
      Name = var.project_name
    }
  
}

data "aws_availability_zones" "azs" {}

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets_cidrs)
  vpc_id                  = aws_vpc.pjt_vpc.id
  cidr_block              = element(var.public_subnets_cidrs, count.index)
  map_public_ip_on_launch = true
  availability_zone       = element(data.aws_availability_zones.azs.names, count.index)

  tags = {
    Name = " ${var.project_name} Public Subnet ${count.index + 1}"
  }
}

resource "aws_route_table" "public_subnets_rt" {
  
    count = length(var.public_subnets_cidrs)
    vpc_id = aws_vpc.pjt_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
      Name = "${var.project_name} Public RT ${count.index + 1}"
    }
  
}

resource "aws_route_table_association" "public_subnets_rt_asso" {

    count          = length(var.public_subnets_cidrs)
    subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
    route_table_id = element(aws_route_table.public_subnets_rt[*].id, count.index)
  
}

resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_subnets_cidrs)
  vpc_id                  = aws_vpc.pjt_vpc.id
  cidr_block              = element(var.private_subnets_cidrs, count.index)
  map_public_ip_on_launch = false
  availability_zone       = element(data.aws_availability_zones.azs.names, count.index)

  tags = {
    Name = " ${var.project_name} Private Subnet ${count.index + 1}"
  }
}

resource "aws_eip" "eip" {

  count = length(data.aws_availability_zones.azs.names)
  vpc   = true

  tags = {
    Name = " ${var.project_name} Elastic IP ${count.index + 1}"
  }
  
}

resource "aws_nat_gateway" "natgw" {

  count         = length(var.public_subnets_cidrs) 
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)
  allocation_id = element(aws_eip.eip[*].id, count.index)

  tags = {
    Name = " ${var.project_name} Nat gateway ${count.index + 1}"
  }

  depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_route_table" "private_subnets_rt" {

  count = length(var.private_subnets_cidrs)

  vpc_id = aws_vpc.pjt_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.natgw[*].id, count.index)
  }

  tags = { 
    Name = "${var.project_name} Private RT ${count.index + 1}"
  }
  
}

resource "aws_route_table_association" "private_subnets_rt_asso" {
  
  count          = length(var.private_subnets_cidrs)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = element(aws_route_table.private_subnets_rt[*].id, count.index)
}