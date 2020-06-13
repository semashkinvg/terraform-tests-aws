resource "aws_vpc_peering_connection" "vpc-peering-connection" {
  peer_vpc_id = aws_vpc. vpc_administrative.id
  vpc_id = aws_vpc.vpc.id
  auto_accept = true
}