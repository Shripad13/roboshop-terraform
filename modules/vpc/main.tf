resource "aws_vpc" "main" {
  cidr_block = var.cidr
  tags = {
    Name = "${var.env}-vpc"
  }
}



module "subnets" {
  source             = "./subnets"
  for_each           = var.subnets
  subnet_name        = each.key
  cidr               = each.value["cidr"]
  availability_zones = var.availability_zones
  vpc_id             = aws_vpc.main.id
  env                = var.env
  ngw_ids            = aws_nat_gateway.ngw.*.id
  vpc_peering_ids    = aws_vpc_peering_connection.main.*.id
}


# Why do we keep outside subnet module?
# we have to create  subnets like  Web, App, DB Route tables needs to accessed NGW  which was created by public Iteration.
### Provision NGW - Also NGW only be associated to Public Subnet 

# Below resource is for Elastic IP of NGW
resource "aws_eip" "ngw" {
  count    = var.subnet_name == "public" ? length(var.cidr) : 0
  instance = aws_instance.web.index
  domain   = "vpc"
}

resource "aws_nat_gateway" "ngw" {
  count = length(var.availability_zones)


  allocation_id = aws_eip.ngw.*.id[count.index]
  subnet_id     = module.subnets["public"].subnets[count.index]

  tags = {
    Name = "ngw-${var.subnet_name}-${var.env}-${split("-", var.availability_zones[count.index])[2]}"
  }

}

# Peering to tools VPC
resource "aws_vpc_peering_connection" "main" {
  for_each = var.peering_vpcs

  peer_vpc_id = each.value["id"]
  vpc_id      = aws_vpc.main.id
  auto_accept = true

  tags = {
    Name = "${each.key}-peer"
  }
}

# Addinf routes to peered VPCs
resource "aws_route" "on_peer_side" {
  for_each                  = var.peering_vpcs
  route_table_id            = each.value["route_table_id"]
  destination_cidr_block    = var.cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main[each.key].id
} 