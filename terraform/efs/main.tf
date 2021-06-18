terraform {
  backend "s3" {
    bucket                  = "gorilla-timeoff-terraform-state-prod"
    key                     = "efs/terraform.tfstate"
    region                  = "us-east-2"
    dynamodb_table          = "gorilla-timeoff-terraform-locks-prod"
    encrypt                 = true
    profile                 = "jlb"
    shared_credentials_file = "auth/credentials"
  }
}

module "efs" {
  source = "git::https://github.com/cloudposse/terraform-aws-efs.git?ref=master"

  namespace       = var.project
  stage           = var.environment
  name            = var.name
  region          = var.aws_region
  vpc_id          = data.aws_vpc.selected.id
  subnets         = tolist(data.aws_subnet_ids.subnet.ids)
  security_groups = [file("../swarm_cluster/output/swarm-sg_id.txt")]
  tags            = var.extra_tags
  #  zone_id            = var.aws_route53_dns_zone_id
}
