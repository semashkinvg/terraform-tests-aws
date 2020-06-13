module "vpc1" {
  source = "../Modules/vpc"
  cidr_block = "10.0.0.0/16"
  purpose = "first"
  project_code = var.project_code
  region = var.region
}
module "vpc2" {
  source = "../Modules/vpc"
  cidr_block = "10.100.0.0/16"
  purpose = "second"
  project_code = var.project_code
  region = var.region
}
