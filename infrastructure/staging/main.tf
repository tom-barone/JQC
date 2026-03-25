variable "OPENTOFU_STATE_ENCRYPTION_PASSWORD" {
  type      = string
  sensitive = true
}

terraform {
  backend "s3" {
    use_lockfile = true
    #key          = <set by -backend-config>
    #bucket       = <set by -backend-config>
  }

  encryption {
    key_provider "pbkdf2" "encryption_key" {
      passphrase = var.OPENTOFU_STATE_ENCRYPTION_PASSWORD
    }
    method "aes_gcm" "encryption_method" {
      keys = key_provider.pbkdf2.encryption_key
    }
    state {
      method   = method.aes_gcm.encryption_method
      enforced = true
    }
    plan {
      method   = method.aes_gcm.encryption_method
      enforced = true
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.6.0, < 7.0.0"
    }
    linode = {
      source  = "linode/linode"
      version = "3.10.0"
    }
  }
}

provider "linode" {}

provider "aws" {}

variable "STAGING_NAME" {
  type = string
}

variable "BACKUP_PRIMARY_S3_BUCKET_NAME" {
  type      = string
  sensitive = true
}

resource "aws_s3_bucket" "backups" {
  bucket = "${var.STAGING_NAME}.${var.BACKUP_PRIMARY_S3_BUCKET_NAME}"
}

variable "LINODE_REGION" {
  type      = string
  sensitive = true
}

variable "ANSIBLE_SSH_PUBLIC_KEY" {
  type = string
}

resource "linode_firewall" "server_firewall" {
  label = "${var.STAGING_NAME}-web-server-firewall"

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
  label           = "${var.STAGING_NAME}-jqc-server"
  tags            = ["staging"]
  image           = "linode/debian13"
  region          = var.LINODE_REGION
  type            = "g6-standard-2"
  authorized_keys = [var.ANSIBLE_SSH_PUBLIC_KEY]
}

output "server_ip_address" {
  value = one(linode_instance.server.ipv4)
}
