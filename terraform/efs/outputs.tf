output "default_vpc" {
  value = data.aws_vpc.selected.id
}

output "Subnets" {
  #count = length(data.aws_subnet_ids.example.ids)
  value = tolist(data.aws_subnet_ids.subnet.ids)[0]
  #value = "element(data.aws_subnet_ids.subnet.ids,0)"
}

##################
# Output to files
##################


# resource "local_file" "vpc_id" {
#   content  = data.aws_vpc.selected.id
#   filename = "output/vpc_id.txt"
# }

# resource "local_file" "public_subnet_id" {
#   content  = data.aws_subnet_ids.subnet.id
#   filename = "output/subnet_id.txt"
# }

# resource "local_file" "region" {
#   content  = var.aws_region
#   filename = "output/aws_region.txt"
# }
/*
resource "local_file" "efs_security_group" {
  content  = aws_security_group.efs.id
  filename = "output/efs-sg_id.txt"
}
*/
