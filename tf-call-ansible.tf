resource "null_resource" "app" {
    depends_on = [ aws_route53_record.main, aws_instance.main ]
    
    count = length(var.components)

#triggers - force something to run every time you apply, even if nothing else has changed.
    triggers = {
      always_run = timestamp()
    }

    connection { # Enables the connection to the remote host
        host = aws_instance.main.*.private_ip[count.index]
        user = data.vault_generic_secret.ssh.data["username"]
        password = data.vault_generic_secret.ssh.data["password"]
        type = "ssh"
    }
    provisioner "remote-exec" { #This lets the execution to hapen on the remote host
      inline = [
        "sudo pip3.11 install ansible",
        "ansible-pull -U https://github.com/Shripad13/roboshop-ansible.git -i localhost, -e vault_token=${vault_token} -e COMPONENET=${COMPONENET} -e ENV=${ENV} main.yml"
      ]
    }
}


# pip3.11 install ansible - bcoz for ansible-pull, ansible is needed