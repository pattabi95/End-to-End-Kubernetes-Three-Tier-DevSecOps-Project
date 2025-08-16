resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
    tags = {
        Name = "${var.project}-vpc"
    }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project}-igw"
  }
}

resource "aws_subnet" "public"{
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.availability_zone
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone
}

resource "aws_eip" "nat" {
    count = 1
    domain = "vpc"
    depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "${var.project}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat[0].id
    subnet_id     = aws_subnet.public.id
    depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name = "${var.project}-nat-gateway"
  }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project}-public-route-table"
  }
}

resource "aws_route" "public" {
    route_table_id         = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.igw.id
    depends_on = [aws_internet_gateway.igw]
    }

resource "aws_route_table_association" "public" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project}-private-route-table"
  }
}

resource "aws_route" "private" {
    route_table_id         = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"    
    nat_gateway_id         = aws_nat_gateway.nat.id
    depends_on = [aws_nat_gateway.nat]
}

resource "aws_route_table_association" "private" {
    subnet_id      = aws_subnet.private.id
    route_table_id = aws_route_table.private.id
}

