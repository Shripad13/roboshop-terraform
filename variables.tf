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