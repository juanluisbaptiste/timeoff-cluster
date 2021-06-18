locals {
  ssh_key_name = "ssh-cluster-${var.environment}"
}

variable "key_path" {
  description = "SSH Public Key path"
  default     = "auth/id_ssh.pub"
}

variable "key_path_private" {
  description = "SSH Public Key path"
  default     = "auth/id_ssh"
}

variable "ssh_key_name" {
  description = "SSH key name"
  default     = "aws-cluster-var.environment"
}

variable "manager_count" {
  description = "managers amount"
}

variable "worker_count" {
  description = "Workers amount"
}

variable "worker_instance_type" {
  description = "Swarm worker Instance type"
}

variable "manager_instance_type" {
  description = "Swarm Manager Instance type"
}

variable "create_nfs_sg" {
  description = "Create NFS security to assign to Manager node"
}

variable "create_efs_sg" {
  description = "Create EFS security to assign to cluster nodes"
}

variable "external_eips" {
  description = "Defeine if elastic ips should be created externally or not"
}
