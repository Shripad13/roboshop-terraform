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

module "eks" {
  depends_on = [ module.db ]   
      source = "./module/eks"
      for_each = var.eks
      component_name = each.key
      env = var.env
      subnet_ids = module.vpc["main"].subnets[each.value["subnet_ref"]].subnets
      eks_cluster_version = each.value["eks_cluster_version"]
      node_groups = each.value["node_groups"]
      addons = each.value["addons"]
}
