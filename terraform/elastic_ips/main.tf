terraform {
  backend "s3" {
    bucket                  = "gorilla-timeoff-terraform-state-prod"
    key                     = "elastic_ips/terraform.tfstate"
    region                  = "us-east-2"
    dynamodb_table          = "gorilla-timeoff-terraform-locks-prod"
    encrypt                 = true
    profile                 = "jlb"
    shared_credentials_file = "auth/credentials"
  }
}
module "external_eips" {
  source                = "git::https://gitlab.com/live9/terraform/modules.git///elastic_ips"
  environment           = var.environment
  aws_region            = var.aws_region
  eip_count             = var.eip_count
}
