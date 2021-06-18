variable "aws_profile" {
  description = "AWS profile"
  default     = "jlb"
}

variable "aws_region" {
  description = "AWS region on which we will setup the swarm cluster"
  default     = "us-east-2"
}

variable "environment" {
  description = "Environment name"
  default     = "prod"
}

variable "project" {
  description = "Project name"
  default     = "gorilla"
}

