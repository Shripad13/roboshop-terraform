# resource "aws_instance" "main" {
#   count                  = length(var.components)
#   ami                    = data.aws_ami.main.image_id
#   instance_type          = "t3.small"
#   vpc_security_group_ids = [aws_security_group.main.*.id[count.index]]

#   tags = {
#     Name = "${var.components[count.index]}-${var.env}"
#   }
# }

module "vpc" {
  for_each = var.vpc

  source = "./module/vpc"

  cidr               = each.value["cidr"]
  subnets            = each.value["subnets"]
  env                = var.env
  availability_zones = each.value["availability_zones"]
  name               = each.key
  peering_vpcs       = each.value["peering_vpcs"]
}


# Once VPC is setup then we can setup the DB 
module "db" {

  depends_on = [ module.vpc ]

  source   = "./module/ec2"
  for_each = var.db_servers

  component_name = each.key

  env           = var.env
  vault_token  = var.vault_token
  ports         = each.value["ports"]
  instance_type = each.value["instance_type"]

  vpc_id       = module.vpc["main"].vpc_id
  zone_id      = var.zone_id
  bastion_host = var.bastion_host
  subnet_ids   = module.vpc["main"].subnet["db"] # we are using the first subnet of the list for DB servers, as we are not using any load balancer for DB servers. If we had a load balancer, then we would have used all the subnets in round robin fashion. 
}

module "app" {

  depends_on = [ module.db ]

  source   = "./module/ec2"
  for_each = var.app_servers

  component_name = each.key

  env           = var.env
  vault_token  = var.vault_token
  ports         = each.value["ports"]
  instance_type = each.value["instance_type"]

  vpc_id       = module.vpc["main"].vpc_id
  zone_id      = var.zone_id
  bastion_host = var.bastion_host
  subnet_ids   = module.vpc["main"].subnet["app"] # we are using the first subnet of the list for DB servers, as we are not using any load balancer for DB servers. If we had a load balancer, then we would have used all the subnets in round robin fashion. 
}


module "web" {

  depends_on = [ module.app ]

  source   = "./module/ec2"
  for_each = var.web_servers

  component_name = each.key

  env           = var.env
  vault_token  = var.vault_token
  ports         = each.value["ports"]
  instance_type = each.value["instance_type"]

  vpc_id       = module.vpc["main"].vpc_id
  zone_id      = var.zone_id
  bastion_host = var.bastion_host
  subnet_ids   = module.vpc["main"].subnet["web"] # we are using the first subnet of the list for DB servers, as we are not using any load balancer for DB servers. If we had a load balancer, then we would have used all the subnets in round robin fashion. 
}

module "load-balancers" {
  depends_on = [ module.web ]
  for_each = var.load_balancers
  source = "./modules/load-balancers"
  component_name = each.key
  load_balancer_type = each.value["load_balancer_type"]
  internal = each.value["internal"]
  env = var.env
  vpc_id       = module.vpc["main"].vpc_id
  subnet_ids   = module.vpc["main"].subnet["public"].subnets
  instance_id  = module.web["frontend"].instance_id
}