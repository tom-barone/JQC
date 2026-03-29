provider "linode" {}

resource "linode_firewall" "server_firewall" {
  label = "${var.ENVIRONMENT}-web-server-firewall"

  inbound {
    label    = "allow-ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }

  inbound {
    label    = "allow-http"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "80"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }

  inbound {
    label    = "allow-https"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "443"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }

  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"

  linodes = [linode_instance.server.id]
}

resource "linode_instance" "server" {
  label           = "${var.ENVIRONMENT}-jqc-server"
  image           = "linode/debian13"
  region          = var.LINODE_REGION
  type            = "g6-standard-2"
  authorized_keys = [var.ANSIBLE_SSH_PUBLIC_KEY]
  root_pass       = var.LINODE_ROOT_PASSWORD
  stackscript_id  = linode_stackscript.harden_ssh.id
}

# Make sure the server is fully up and ready to go before 
# connecting with Ansible.
resource "terraform_data" "wait_for_new_server" {
  triggers_replace = [
    linode_instance.server.id
  ]

  provisioner "local-exec" {
    command = <<EOT
      sleep 120
    EOT
  }
}

# I get choked out of my own VM from damn hacker fools trying to brute force my SSH
# This will hopefully kick out enough of them to let me in and harden further.
resource "linode_stackscript" "harden_ssh" {
  label       = "harden-ssh"
  images      = ["linode/debian13"]
  description = "Harden SSH enough to keep bots out and let us log in to do further hardening with Ansible."
  script      = <<-EOF
    #!/bin/bash
    sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
    sed -i 's/^#*MaxAuthTries.*/MaxAuthTries 3/' /etc/ssh/sshd_config
    systemctl restart sshd
  EOF
}
