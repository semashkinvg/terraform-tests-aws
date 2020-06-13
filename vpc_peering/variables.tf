variable "project_code" {
  default = "peering"
}

variable "region" {
  default = "eu-west-1"
}

variable "teraform_state_s3_bucket" {
  default = "test-aws-itwas-me"
}

variable "aws_ami_default_id" {
  description = "AMI id used by default. It's Amazon Linux2 now."
  type        = string
  default     = "ami-06ce3edf0cff21f07"
}



variable "aws_ec2_pubkey" {
  description = "Public key for EC2"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDcf2+GUNct8ax8bcv/pzhKqp6wEYJgw8nKmFJ8nMnbgbVrd8PLr778mlB1GkcG9XbW6A3d9wI95jM3At4mP7i1qrxLqef9orPe1yb6GBx0advV+wt3pje/rMOm4/cozHbq2yoCuJQpxLhvHumwefXqMf5nGqsQBpE7Rrujy+yrY9C6vwdyRiaisTFsbEUtttqXPG0FwXruwiOcJGKuu37YVY5QvpM9c4jDg/GWLeRuiMURqio+dLGAVCKKlr+bfA2VDV+stZ6FmUEmcuvb34xIpin10XPfr6PigWuJXbBh1WuGw56Ay6AVZA6eVfs25ZOnspD6FtrqHaifK2rk/kAZIWgh/Q2Ue2zZeDdrWuHx0OH4nJfhuCeo0r5FYsRe68wPqMCRnk3YWMJygwOndJwVyKt56RM27ge2dhrGjJ1P+22Q0suSAmf/aUlLvLgSXynTOJNqyByeyk/Ar10PGj0t/d6hqH09mZdf5t6gNgYZTmbUR3EZsp3RxOVB/OeKpgM= Vladimir_Semashkin@EPRUSAML0093"
}