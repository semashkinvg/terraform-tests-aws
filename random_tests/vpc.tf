resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags= {
    Name="${var.region}-${var.project_code}-vpc"
  }
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_vpc" "vpc_administrative" {
  cidr_block = "10.100.0.0/16"
  tags= {
    Name="${var.region}-${var.project_code}-vpc"
  }
  enable_dns_hostnames = true
  enable_dns_support = true
}

module "private_subnet" {
  source = "..\/Modules\/subnet"
  cidr_block = "10.0.1.0/24"
  project_code = var.project_code
  region = var.region
  vpc_id = aws_vpc.vpc.id
}


module "public_subnet_admin" {
  source = "..\/Modules\/subnet"
  cidr_block = "10.100.1.0/24"
  project_code = var.project_code
  region = var.region
  vpc_id = aws_vpc.vpc_administrative.id
  is_public = true
}

resource "aws_security_group" "sg_internal_resouce" {
  name = "${var.region}-${var.project_code}-sg-internal-resource"
  vpc_id = aws_vpc.vpc.id
}
resource "aws_security_group_rule" "sg_rule_allow_everything_to_bastion" {
  from_port = 0
  protocol = "all"
  security_group_id = aws_security_group.sg_internal_resouce.id
  to_port = 0
  type = "ingress"
  source_security_group_id = aws_security_group.sg_bastion.id
}
resource "aws_security_group_rule" "sg_rule_outbound_allow_all_internal_Resouce" {
  from_port = 0
  protocol = "all"
  security_group_id = aws_security_group.sg_internal_resouce.id
  to_port = 0
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}


resource "aws_eip" "nat_gw_epi" {
  tags ={
    Name="${var.project_code}-${var.region}-igw"
  }
}

resource "aws_nat_gateway" "nat_gw_a" {
  allocation_id = aws_eip.nat_gw_epi.id
  subnet_id = module.public_subnet_a.subnet_id
}

resource "aws_route" "route_to_nat_gateway" {
  route_table_id = aws_vpc.vpc.default_route_table_id
  gateway_id = aws_nat_gateway.nat_gw_a.id
  destination_cidr_block = "0.0.0.0/0"
}
