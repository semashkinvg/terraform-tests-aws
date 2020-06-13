resource "aws_vpc_peering_connection" "vpc-peering-connection" {
  peer_vpc_id = module.vpc1.vpc_id
  vpc_id = module.vpc2.vpc_id
  auto_accept = true
}

resource "aws_route" "route_to_peering_vpc1_to_vpc2" {
  route_table_id = module.vpc1.vpc_default_route_table_id
  gateway_id = aws_vpc_peering_connection.vpc-peering-connection.id
  destination_cidr_block = module.vpc2.vpc_cidr
  depends_on = [aws_vpc_peering_connection.vpc-peering-connection]
}

resource "aws_route" "route_to_peering_vpc2_to_vpc1" {
  route_table_id = module.vpc2.vpc_default_route_table_id
  gateway_id = aws_vpc_peering_connection.vpc-peering-connection.id
  destination_cidr_block = module.vpc1.vpc_cidr
  depends_on = [aws_vpc_peering_connection.vpc-peering-connection]
}