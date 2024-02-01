resource "aws_vpc" "eks_vpc" {
  
  cidr_block                       = var.eks_vpc_cidr
  enable_dns_hostnames             = true
  enable_dns_support               = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name = "EKS_cluster"
  }
}

resource "aws_internet_gateway" "eks_igw" {
  
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "EKS IGW"
  }
}

data "aws_availability_zones" "azs" {}

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets_cidrs)
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = element(var.public_subnets_cidrs, count.index)
  map_public_ip_on_launch = true
  availability_zone       = element(data.aws_availability_zones.azs.names, count.index)

  tags = {
    Name = "Public subnet ${count.index + 1}"
    "kubernetes.io/cluster/${var.project_name}" = "shared"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_route_table" "eks_rt" {

  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }
  
  tags = {
    Name = "EKS RT"
  }
}

resource "aws_route_table_association" "public_subnets_asso" {

  count          = length(var.public_subnets_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.eks_rt.id
  
}

resource "aws_subnet" "private_subnets" {

  count             = length(var.private_subnets_cidrs)
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = element(var.private_subnets_cidrs, count.index)
  availability_zone = element(data.aws_availability_zones.azs.names, count.index)
  
    tags = {
      Name = "Private subnet ${count.index + 1}"
      "kubernetes.io/cluster/${var.project_name}" = "shared"
      "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_eip" "eip" {
  vpc      = true

  tags = {
    Name = "eks-eip"
  }
}

resource "aws_nat_gateway" "natgw" {

  subnet_id     = aws_subnet.public_subnets[0].id
  allocation_id = aws_eip.eip.id

  tags = {
    Name = "NatGw"
  }

  depends_on = [ aws_internet_gateway.eks_igw ]
  
}

resource "aws_route_table" "private_eks_rt" {

  vpc_id   = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw.id
  }
  
  tags = {
    Name = "private EKS RT"
  }
}

resource "aws_route_table_association" "private_subnets_asso" {

  count          = length(var.private_subnets_cidrs)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.private_eks_rt.id
  
}




