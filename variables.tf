# variable "components" {
#   default = [
#     "mongodb",
#     "catalogue",
#     "user",
#     "redis",
#     "cart",
#     "mysql",
#     "shipping",
#     "rabbitmq",
#     "payment",
#     "frontend"
#   ]
# }

variable "vpc" {}
variable "env" {}
variable "vault_token" {}
#variable "peering_vpcs" {}

variable "db_servers" {}
variable "def_vpc_cidr" {}
variable "bastion_host" {}

variable "subnet_ids" {}
variable "zone_id" {}

variable "app_servers" {}
variable "web_servers" {}

variable "load_balancers" {}
variable "instance_id" {}