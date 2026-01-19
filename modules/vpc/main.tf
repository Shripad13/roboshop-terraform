resource "aws_vpc" "main" {
      cidr_block = var.cidr
      tags ={
        Name = "${var.env}-vpc"
      }
}



module "subnets" {
    source = "./subnets"
    for_each = var.subnets
    subnet_name = each.key
    cidr = each.value["cidr"]
    availability_zones = var.availability_zones
    vpc_id =aws_vpc.main.id
    env = var.env
}

