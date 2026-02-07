# Provision Application servers using Ansible Pull method. We are using null resource to run Ansible Pull command on the EC2 instances after provisioning them. We are using remote-exec provisioner to run the Ansible Pull command on the EC2 instances. We are using Vault to fetch the SSH credentials for the EC2 instances. We are using triggers to run the provisioner every time we run terraform apply, as we want to run the Ansible Pull command every time we make changes to the Ansible playbook or inventory file.

resource "null_resource" "app" {
  depends_on = [aws_route53_record.main, aws_instance.main]

  triggers = {
    always_run = timestamp()
  }
  provisioner "remote-exec" {
    connection {
      host     = aws_instance.main.private_ip
      user     = data.vault_generic_secret.ssh.data["username"]
      password = data.vault_generic_secret.ssh.data["password"]
    }

    inline = [
      "sudo pip3.11 install ansible",
      "sudo pip3.11 install hvac",
    "ansible-pull -U https://github.com/roboshop-ansible/${var.components[count.index]}-ansible.git -e component=${var.component_name} -e env=${var.env} -e vault_token=${vault_token} main.yml"]

  }
}