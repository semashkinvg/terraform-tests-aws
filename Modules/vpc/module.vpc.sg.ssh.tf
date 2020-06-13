resource "aws_security_group" "sg_default_ssh" {
  name = "${var.region}-${var.project_code}-${var.purpose}-ssh-sg"
  vpc_id = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "sh_default_rule_ssh" {
  from_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.sg_default_ssh.id
  to_port = 22
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sg_rule_outbound_allow_all_ssh" {
  from_port = 0
  protocol = "all"
  security_group_id = aws_security_group.sg_default_ssh.id
  to_port = 0
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}
