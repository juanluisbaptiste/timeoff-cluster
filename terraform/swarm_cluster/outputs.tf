output "swarm_managers_elastic_ip_address" {
  value = module.swarm_cluster.swarm_managers_eip
}

output "swarm_managers_public_ip_addresses" {
  value = module.swarm_cluster.swarm_managers_public_ip_addresses
}

output "swarm_managers_aws_hostnames" {
  description = "List of public DNS names assigned to the instances. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = module.swarm_cluster.swarm_managers_aws_hostnames
}

output "swarm_managers_private_ip_addresses" {
  value = module.swarm_cluster.swarm_managers_private_ip_addresses
}

output "swarm_workers_aws_hostnames" {
  value = module.swarm_cluster.swarm_workers_aws_hostnames
}

output "swarm_workers_private_ip_addresses" {
  value = module.swarm_cluster.swarm_workers_private_ip_addresses
}
