#version - 5.77.0, copied from TF website

resource "aws_eks_cluster" "main" {
  name     = "${var.env}-eks"
  role_arn = aws_iam_role.eks_roles.arn
  version = var.eks_cluster_version

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}   
