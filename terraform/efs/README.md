# AWS EFS filesystem creation 

Project to create an AWS EFS shared filesystem. It should be run _after_ creating the [swarm cluster](https://gitlab.com/live9/terraform/modules/-/tree/master/swarm_cluster) as it needs to know the ID of the VPC and security group to which it should be given access. From ansible you just have to mount the EFS.

## Usage

Checkout the module's [documentation](https://gitlab.com/live9/terraform/modules/-/tree/master/swarm_cluster/README.md).

## Requirements

Uses terraform  >= 0.12.x
