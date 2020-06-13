resource "aws_key_pair" "bootstrap_keypair" {
  key_name = "terraform_keypair"
  public_key = var.aws_ec2_pubkey
  tags = {
    Name = "My fucking key"
  }
}

data "aws_iam_policy" "s3_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role" "ec2_s3_full_access_role" {
  name = "EC2S3FullAccess"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2_s3_full_access_role_and_policy_attachement" {
  policy_arn = data.aws_iam_policy.s3_full_access.arn
  role = aws_iam_role.ec2_s3_full_access_role.name
}

resource "aws_iam_instance_profile" "ec2_s3_full_access_iam_profile" {
  name = "ec2-s3-full-access-profile"
  role = aws_iam_role.ec2_s3_full_access_role.name
}
//
//resource "aws_instance" "bastion" {
//  ami = var.aws_ami_default_id
//  instance_type = "t2.micro"
//  key_name = aws_key_pair.bootstrap_keypair.key_name
//
//  vpc_security_group_ids = [aws_security_group.sg_bastion.id]
//
//  subnet_id = module.public_subnet_a.subnet_id
//
//  tags = {
//    Name="${var.region}-${var.project_code}-bastion"
//  }
//}

resource "aws_instance" "internal_ec2" {
  ami = var.aws_ami_default_id
  instance_type = "t2.micro"
  key_name = aws_key_pair.bootstrap_keypair.key_name

  vpc_security_group_ids = [aws_security_group.sg_bastion.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_full_access_iam_profile.name

  subnet_id = module.public_subnet_a.subnet_id
  user_data = <<EOF
  yum update -y
  yum install httpd -y
  systemctl enable httpd service
  systemctl start httpd service
  eacho "<html>asdasd</htnml>" > /var/www/html/index.html"
EOF
  tags = {
    Name="${var.region}-${var.project_code}-public-resouce"
  }
}

resource "aws_instance" "internal_ec2_2" {
  ami = var.aws_ami_default_id
  instance_type = "t2.micro"
  key_name = aws_key_pair.bootstrap_keypair.key_name

  vpc_security_group_ids = [aws_security_group.sg_bastion.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_full_access_iam_profile.name

  subnet_id = module.public_subnet_b.subnet_id
  user_data = <<EOF
  yum update -y
  yum install httpd -y
  systemctl enable httpd service
  systemctl start httpd service
  eacho "<html>asdasd2</htnml>" > /var/www/html/index.html"
EOF
  tags = {
    Name="${var.region}-${var.project_code}-public-resouce"
  }
}

resource "aws_instance" "public_in_admin_vpc_ec2_2" {
  ami = var.aws_ami_default_id
  instance_type = "t2.micro"
  key_name = aws_key_pair.bootstrap_keypair.key_name

  vpc_security_group_ids = [aws_security_group.sg_bastion.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_full_access_iam_profile.name

  subnet_id = module.public_subnet_b.subnet_id
  user_data = <<EOF
  yum update -y
  yum install httpd -y
  systemctl enable httpd service
  systemctl start httpd service
  eacho "<html>asdasd2</htnml>" > /var/www/html/index.html"
EOF
  tags = {
    Name="${var.region}-${var.project_code}-public-resouce"
  }
}

resource "aws_lb_target_group" "tg_web" {
  name     = "alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  target_type = "instance"
}

resource "aws_lb" "elb" {
  internal           = false
  load_balancer_type = "application"
  subnets = [module.public_subnet_b.subnet_id,module.public_subnet_a.subnet_id]
//  cross_zone_load_balancing = true
//  idle_timeout = 500
//  connection_draining = true
//  connection_draining_timeout = 500
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_web.arn
  }
}
resource "aws_lb_target_group_attachment" "target_group_attachment_1" {
  target_group_arn = aws_lb_target_group.tg_web.arn
  target_id = aws_instance.internal_ec2.id
}
resource "aws_lb_target_group_attachment" "target_group_attachment_2" {
  target_group_arn = aws_lb_target_group.tg_web.arn
  target_id = aws_instance.internal_ec2_2.id
}