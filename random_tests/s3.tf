resource "aws_s3_bucket" "s3_general" {
  bucket = "${var.project_code}-general-data"
  acl = "private"

  tags = {
  }
  versioning {
    enabled = true
  }
}

