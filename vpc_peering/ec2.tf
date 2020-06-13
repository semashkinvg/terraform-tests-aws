
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




data "template_file" "user_datae_ec2_1" {
  template = file("./user_data_ec2_1.sh")
}

data "template_file" "user_datae_ec2_2" {
  template = file("./user_data_ec2_2.sh")
}

resource "aws_instance" "public_ec2_1" {
  ami = var.aws_ami_default_id
  instance_type = "t2.micro"
  key_name = aws_key_pair.bootstrap_keypair.key_name

  vpc_security_group_ids = [module.vpc1.default_ssh_sg_id, module.vpc1.default_http_sg_id]
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_full_access_iam_profile.name

  subnet_id = module.vpc1.public_sunet_id
  user_data = data.template_file.user_datae_ec2_1.rendered
  tags = {
    Name="${var.region}-${var.project_code}-public-resouce1"
  }
}



resource "aws_instance" "public_ec2_2" {
  ami = var.aws_ami_default_id
  instance_type = "t2.micro"
  key_name = aws_key_pair.bootstrap_keypair.key_name

  vpc_security_group_ids = [module.vpc2.default_ssh_sg_id, module.vpc2.default_http_sg_id]
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_full_access_iam_profile.name

  subnet_id = module.vpc2.public_sunet_id
  user_data = data.template_file.user_datae_ec2_2.rendered
  tags = {
    Name="${var.region}-${var.project_code}-public-resouce2"
  }
}
