variable "purpose" {

}

variable "region" {

}

variable "project_code" {

}

variable "cidr_block" {

}

variable "enable_dns_hostnames" {
  default = true
}

variable "enable_dns_support" {
  default = true
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_default_route_table_id" {
  value = aws_vpc.vpc.default_route_table_id
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "public_sunet_id" {
  value = module.public_subnet.subnet_id
}

output "default_ssh_sg_id" {
  value = aws_security_group.sg_default_ssh.id
}

output "default_http_sg_id" {
  value = aws_security_group.sg_default_http.id
}

output "nat_route_table_id" {
  value = aws_route_table.route_table_to_nat.id
}