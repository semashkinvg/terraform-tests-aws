resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  tags= {
    Name="${var.region}-${var.project_code}-${var.purpose}-vpc"
  }
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
}


module "public_subnet" {
  source = "../subnet"
  cidr_block = cidrsubnet(var.cidr_block, 8, 0)
  project_code = var.project_code
  region = var.region
  purpose = var.purpose
  vpc_id = aws_vpc.vpc.id
  is_public = true
}