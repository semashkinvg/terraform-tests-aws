resource "aws_route53_zone" "itwasme-private" {
  name = "itwasme.com"

  vpc {
    vpc_id = aws_vpc.vpc.id
  }
}



resource "aws_route53_record" "itwasme-dev-a" {
  zone_id = aws_route53_zone.itwasme-private.id
  name    = "dev.itwasme.com"
  type    = "A"
  ttl     = "30"

  records = [
    aws_instance.internal_ec2.private_ip
  ]
}


resource "aws_security_group" "sg_route53_resolver_endpoint" {
  name = "${var.region}-${var.project_code}-sg-route53-resolver-endpoint"
  vpc_id = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "sg_rulte_outbound_route53_resolver_endpoint" {
  from_port = 0
  protocol = "all"
  security_group_id = aws_security_group.sg_route53_resolver_endpoint.id
  to_port = 0
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_route53_resolver_endpoint" "itwasme-endpoint" {
  name      = "itwasme-endpoint"
  direction = "INBOUND"

  security_group_ids = [
    aws_security_group.sg_route53_resolver_endpoint.id
  ]

  ip_address {
    subnet_id = module.public_subnet_b.subnet_id
  }

  ip_address {
    subnet_id = module.public_subnet_a.subnet_id
  }

  tags = {
    Environment = "Prod"
  }
}