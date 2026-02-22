# we are fetching the OIDC value from this file
locals {
    OIDC_PROVIDER = split("/", aws_eks_cluster.main.identity[0].oidc[0])[4]
}

# To get output, Use as below wherever you want
# local.OIDC_PROVIDER