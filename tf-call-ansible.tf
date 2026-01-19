# This is the file where After Infra creation by Terraform, it will call the Ansible Playbooks for Config Management

resource "null_resource" "app" {
  depends_on = [aws_route53_record.main, aws_instance.main]

  count = length(var.components)

  #triggers - force something to run every time you apply, even if nothing else has changed.
  triggers = {
    always_run = timestamp()
  }

  provisioner "remote-exec" { #This lets the execution to hapen on the remote host

    connection { # Enables the connection to the remote host
      host     = aws_instance.main.*.private_ip[count.index]
      user     = data.vault_generic_secret.ssh.data["username"]
      password = data.vault_generic_secret.ssh.data["password"]
    }

    inline = [
      "sudo pip3.11 install ansible",
      "sudo pip3.11 install hvac",
      "ansible-pull -U https://github.com/Shripad13/roboshop-ansible.git -i localhost, -e vault_token=${var.vault_token} -e component=${var.components[count.index]} -e env=${var.env} main.yml"
    ]
  }
}


# pip3.11 install ansible - bcoz for ansible-pull, ansible is needed
# ip3.11 install hvac - package required for Rabbitmq