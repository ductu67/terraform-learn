resource "aws_vpc" "tier_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "tier_vpc"
  }
}

data "aws_availability_zones" "available"{

}

resource "aws_internet_gateway" "tier_internet_gateway" {
  vpc_id = aws_vpc.tier_vpc.id
  tags = {
    Name = "tier_ig"
  }
}

resource "aws_subnet" "tier_public_subnets" {
    vpc_id = aws_vpc.tier_vpc.id
    count = var.public_sn_count
    cidr_block = "10.123.${10 + count.index}.0/24"
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags = {
      Name = "tier_public_subnet_${count.index + 1}"
    }
}

resource "aws_route_table" "tier_public_rt" {
  vpc_id = aws_vpc.tier_vpc.id
  tags = {
    Name = "tier_public_rt"
  }
}

resource "aws_route_table_association" "tier_public_assoc" {
  route_table_id = aws_route_table.tier_public_rt.id
  count = var.public_sn_count
  subnet_id = aws_subnet.tier_public_subnets.id
}

resource "aws_route" "public_subnets_rt" {
  route_table_id = aws_route_table.tier_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.tier_internet_gateway.id
}

resource "aws_eip" "tier_ngw" {
  domain = "vpc"
}

resource "aws_nat_gateway" "tier_vpc" {
  subnet_id = aws_subnet.tier_public_subnets.id
  allocation_id = aws_eip.tier_ngw.id

}

resource "aws_subnet" "tier_private_subnets" {
    vpc_id = aws_vpc.tier_vpc.id
    count = var.private_sn_count
    cidr_block = "10.123.${20 + count.index}.0/24"
    map_public_ip_on_launch = false
    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags = {
      Name = "tier_private_subnet_${count.index + 1}"
    }
}

resource "aws_route_table" "tier_private_rt" {
  vpc_id = aws_vpc.tier_vpc.id
  tags = {
    Name = "tier_private_rt"
  }
}

resource "aws_route_table_association" "tier_private_assoc" {
  route_table_id = aws_route_table.tier_private_rt.id
  count = var.private_sn_count
  subnet_id = aws_subnet.tier_private_subnets.id
}

resource "aws_subnet" "tier_private_db" {
  vpc_id = aws_vpc.tier_vpc.id
    count = var.private_sn_count
    cidr_block = "10.123.${40 + count.index}.0/24"
    map_public_ip_on_launch = false
    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags = {
      Name = "tier_private_db_subnet_${count.index + 1}"
    }
}

# SG for bastion host

resource "aws_security_group" "tier_bastion_sg" {
  name = "tier_sg_bastion"
  vpc_id = aws_vpc.tier_vpc.id

  ingress = {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_block = var.access_ip
  }

  egress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_block = "0.0.0.0/0"
  }

}

resource "aws_security_group" "tier_frontend_sg" {
  name = "tier_sg_fe"
  vpc_id = aws_vpc.tier_vpc.id

  ingress = {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.tier_bastion_sg.id] 
  }

  egress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_block = "0.0.0.0/0"
  }
  
}


resource "aws_security_group" "tier_lb_sg" {
  name = "tier_lb_sg"
  vpc_id = aws_vpc.tier_vpc.id

  dynamic "ingress" {
    for_each = toset(22)
    content {
        from_port = ingress.value
        to_port = ingress.value
        protocol = "tcp"
        security_groups = [aws_security_group.tier_bastion_sg.id]
    }
  }

  egress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_block = "0.0.0.0/0"
  }
}