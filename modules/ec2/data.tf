# Data source block  to fetch the latest Amazon Linux  AMI ID
data "aws_ami" "main" {
  most_recent = true
  name_regex  = "b58-golden-image"
  owners      = ["137112412989"] # Amazon AMI owner ID
}

data "vault_generic_secret" "ssh" {
  path = "common/ssh-creds"
}