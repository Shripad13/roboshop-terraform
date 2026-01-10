data "aws_ami" "main" {
    most_recent = true
    name_regex = "DevOps-LabImage-RHEL9"
    owners     = ["AC_ID"]
}

# Get SSH Info
data "vault_generic_secret" "ssh" {
  path = "common/ssh-creds"
}

data "template_file" "example_template" {
  template = file("./example.tmpl")
  vars = {
    username = data.vault_generic_secret.example_creds.data["username"]
    password = data.vault_generic_secret.example_creds.data["password"]
  }
} 