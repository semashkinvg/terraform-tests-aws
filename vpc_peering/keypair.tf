resource "aws_key_pair" "bootstrap_keypair" {
  key_name = "terraform_keypair"
  public_key = var.aws_ec2_pubkey
  tags = {
    Name = "My fucking key"
  }
}