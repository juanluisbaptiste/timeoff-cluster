terraform {
  backend "s3" {
  bucket                  = "gorilla-timeoff-terraform-state-prod"
  key                     = "swarm_cluster/terraform.tfstate"
  region                  = "us-east-2"
  dynamodb_table          = "gorilla-timeoff-terraform-locks-prod"
  encrypt                 = true
  profile                 = "jlb"
  shared_credentials_file = "auth/credentials"
  }
}

module "swarm_cluster" {
  source = "git::https://gitlab.com/live9/terraform/modules.git///swarm_cluster"
  #  source                = "../modules/swarm_cluster"
  environment           = var.environment
  project               = var.project
  aws_region            = var.aws_region
  manager_count         = var.manager_count
  worker_count          = var.worker_count
  manager_instance_type = var.manager_instance_type
  worker_instance_type  = var.worker_instance_type
  key_path              = var.key_path
  private_key_default   = var.key_path_private
  ssh_key_name          = local.ssh_key_name
  create_nfs_sg         = var.create_nfs_sg
  create_efs_sg         = var.create_efs_sg
  external_eips         = var.external_eips
}
