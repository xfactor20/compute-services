resource "aws_subnet" "private_zone1" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.private_zone1_subnet_cidr
    availability_zone = var.aws_az1

    tags = {
      "Name"                                           = "${lower(var.app_name)}-private-zone1"
      "kubernetes.io/role/internal-elb"                = "1"
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    }
}

resource "aws_subnet" "private_zone2" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.private_zone2_subnet_cidr
    availability_zone = var.aws_az2

    tags = {
      "Name"                                           = "${lower(var.app_name)}-private-zone2"
      "kubernetes.io/role/internal-elb"                = "1"
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    }
}

resource "aws_subnet" "public_zone1" {
    vpc_id     = aws_vpc.vpc.id
    cidr_block = var.public_zone1_subnet_cidr
    availability_zone = var.aws_az1
    map_public_ip_on_launch = true

    tags = {
      "Name"                                           = "${lower(var.app_name)}-public-zone1"
      "kubernetes.io/role/elb"                         = 1
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    }
}

resource "aws_subnet" "public_zone2" {
    vpc_id     = aws_vpc.vpc.id
    cidr_block = var.public_zone2_subnet_cidr
    availability_zone = var.aws_az1
    map_public_ip_on_launch = true

    tags = {
      "Name"                                           = "${lower(var.app_name)}-public-zone2"
      "kubernetes.io/role/elb"                         = 1
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    }
}