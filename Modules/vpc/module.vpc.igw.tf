
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags ={
    Name="${var.project_code}-${var.region}-${var.purpose}-igw"
  }
}

resource "aws_route" "route_to_internet_gateway" {
  route_table_id = aws_vpc.vpc.default_route_table_id
  gateway_id = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
  depends_on = [aws_internet_gateway.igw]
}
