data "aws_vpc" "selected" {
  # default = true
  id = file("../swarm_cluster/output/vpc_id.txt")
}

data "aws_subnet_ids" "subnet" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:public"
    values = ["false"]
  }
}
