
variable "vpc_id" {
  description = "VPC ID"
  default     = "data.aws_vpc.selected.id"
}

variable "private_subnets" {
  description = "Private subnet"
  default     = "data.aws_subnet_ids.subnet.ids"
}

variable "extra_tags" {
  default = {
    Group       = "efs-gorilla-prod"
    Environment = "prod"
  }
}

variable "name" {
  description = "EFS resource name"
}
