resource "aws_security_group" "sg_default_http" {
  name = "${var.region}-${var.project_code}-${var.purpose}-http-sg"
  vpc_id = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "sg_default_rule_http" {
  from_port = 80
  protocol = "tcp"
  security_group_id = aws_security_group.sg_default_http.id
  to_port = 80
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sg_rule_outbound_allow_all_http" {
  from_port = 0
  protocol = "all"
  security_group_id = aws_security_group.sg_default_http.id
  to_port = 0
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}
