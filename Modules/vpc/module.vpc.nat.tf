
resource "aws_eip" "nat_gw_epi" {
  tags ={
    Name="${var.project_code}-${var.region}-${var.purpose}-nat-gw"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw_epi.id
  subnet_id = module.public_subnet.subnet_id
}

resource "aws_route_table" "route_table_to_nat" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "route_to_nat_gateway" {
  route_table_id = aws_route_table.route_table_to_nat.id
  nat_gateway_id = aws_nat_gateway.nat_gw.id
  destination_cidr_block = "0.0.0.0/0"
  depends_on = [aws_nat_gateway.nat_gw]
}
