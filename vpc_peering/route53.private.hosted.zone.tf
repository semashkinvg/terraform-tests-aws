resource "aws_route53_zone" "phz-example-com" {
  name = "example.com"
  vpc {
    vpc_id =  module.vpc1.vpc_id
  }
}
resource "aws_route53_zone_association" "phz-example-com-vpc2-association" {
  vpc_id = module.vpc2.vpc_id
  zone_id = aws_route53_zone.phz-example-com.id
}

resource "aws_route53_record" "phz-example-com-record-ec2-1" {
  name = "ec2-1.example.com"
  type = "A"
  zone_id = aws_route53_zone.phz-example-com.id
  records = [aws_instance.public_ec2_1.private_ip]
  ttl = 30
}
resource "aws_route53_record" "phz-example-com-record-ec2-2" {
  name = "ec2-2.example.com"
  type = "A"
  zone_id = aws_route53_zone.phz-example-com.id
  records = [aws_instance.public_ec2_2.private_ip]
  ttl = 30
}