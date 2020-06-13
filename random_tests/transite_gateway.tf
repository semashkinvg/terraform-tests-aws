resource "aws_ec2_transit_gateway" "aws_transit_gateway" {
  description = "example"
  tags {
    Name="my-transit-gateway"
  }
}

resource "aws_ec2_transit_gateway_peering_attachment" "example" {
  peer_account_id         = aws_ec2_transit_gateway.peer.owner_id
  peer_region             = data.aws_region.peer.name
  peer_transit_gateway_id = aws_ec2_transit_gateway.peer.id
  transit_gateway_id      = aws_ec2_transit_gateway.local.id

  tags = {
    Name = "TGW Peering Requestor"
  }
}