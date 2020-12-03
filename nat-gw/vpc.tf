resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags= {
    Name="${var.region}-${var.project_code}-vpc"
  }
  enable_dns_hostnames = true
  enable_dns_support = true
}

variable "az_s" {
  type = map
  default = {"1":"a", "2":"b", "3":"c"}
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags ={
    Name="${var.project_code}-${var.region}-igw"
  }
}

module "private_subnet" {
  for_each = var.az_s
  source = "../Modules/subnet"
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, each.key)
  project_code = var.project_code
  region = var.region
  vpc_id = aws_vpc.vpc.id
  az = each.value
  purpose = "private-${each.value}"
}
resource "aws_route_table" "rt_private" {
  for_each = var.az_s
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name="${var.project_code}-${var.region}-${each.value}-rt"
  }
}

module "public_subnet" {
  for_each = var.az_s
  source = "../Modules/subnet"
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, each.key+3)
  project_code = var.project_code
  region = var.region
  vpc_id = aws_vpc.vpc.id
  az = each.value
  purpose = "public-${each.value}"
  is_public = true
}

resource "aws_route_table_association" "rt_association" {
  for_each = var.az_s
  route_table_id = aws_route_table.rt_private[each.key].id
  subnet_id = module.public_subnet[each.key].subnet_id
}

//
//resource "aws_security_group" "sg_internal_resouce" {
//  name = "${var.region}-${var.project_code}-sg-internal-resource"
//  vpc_id = aws_vpc.vpc.id
//}
//
//resource "aws_security_group_rule" "sg_rule_outbound_allow_all_internal_Resouce" {
//  from_port = 0
//  protocol = "all"
//  security_group_id = aws_security_group.sg_internal_resouce.id
//  to_port = 0
//  type = "egress"
//  cidr_blocks = ["0.0.0.0/0"]
//}


resource "aws_eip" "nat_gw_epi" {
  for_each = var.az_s
  tags ={
    Name="${var.project_code}-${var.region}-igw-${each.value}"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  for_each = module.public_subnet
  allocation_id = aws_eip.nat_gw_epi[each.key].id
  subnet_id = each.value.subnet_id
}

resource "aws_route" "route_to_nat" {
  for_each = var.az_s
  route_table_id = aws_route_table.rt_private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw[each.key].id
}
