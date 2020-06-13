
module "public_subnet_a" {
  source = "..\/Modules\/subnet"
  cidr_block = "10.0.10.0/24"
  project_code = var.project_code
  region = var.region
  vpc_id = aws_vpc.vpc.id
  is_public = true
}


module "public_subnet_b" {
  source = "..\/Modules\/subnet"
  cidr_block = "10.0.11.0/24"
  project_code = var.project_code
  region = var.region
  vpc_id = aws_vpc.vpc.id
  is_public = true
  az = "b"
}


resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.vpc.id
  tags ={
    Name="${var.project_code}-${var.region}-public_route"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags ={
    Name="${var.project_code}-${var.region}-igw"
  }
}

resource "aws_route" "route" {
  route_table_id = aws_route_table.route_table_public.id
  gateway_id = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "route_table_public_subnet_association_a" {
  route_table_id = aws_route_table.route_table_public.id
  subnet_id = module.public_subnet_a.subnet_id
}

resource "aws_route_table_association" "route_table_public_subnet_association_b" {
  route_table_id = aws_route_table.route_table_public.id
  subnet_id = module.public_subnet_b.subnet_id
}


resource "aws_security_group" "sg_bastion" {
  name = "${var.region}-${var.project_code}-sg-bastion"
  vpc_id = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "sg_rule_allow_22" {
  from_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.sg_bastion.id
  to_port = 22
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sg_rule_outbound_allow_all" {
  from_port = 0
  protocol = "all"
  security_group_id = aws_security_group.sg_bastion.id
  to_port = 0
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}
