resource "aws_subnet" "subnet" {
  cidr_block = var.cidr_block
  vpc_id = var.vpc_id
  tags= {
    Name="${var.project_code}-${var.region}-${var.purpose}-${var.cidr_block}-subnet"
  }
  availability_zone = "${var.region}${var.az}"
  map_public_ip_on_launch = var.is_public
}


output "subnet_id" {
  value = aws_subnet.subnet.id
}

output "subnet_az" {
  value = aws_subnet.subnet.availability_zone
}