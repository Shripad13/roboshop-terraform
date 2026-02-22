# Provision nodepool means group of similar instances for hosting frontend & Backend appln
# we can have 1 or more than 1 instance group. This helps in running different type of workloads on different type of machines.

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = each.key
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = var.subnet_ids
  capacity_type   = each.value["capacity_type"]
  instance_types  = each.value["instance_types"]

  scaling_config {
    desired_size = each.value["min_nodes"]
    max_size     = each.value["max_nodes"]
    min_size     = each.value["min_nodes"]
  }

}