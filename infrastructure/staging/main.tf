variable "opentofu_state_encryption_password" {
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
      passphrase = var.opentofu_state_encryption_password
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

variable "staging_name" {
  type = string
}

variable "backup_primary_s3_bucket_name" {
  type      = string
  sensitive = true
}

resource "aws_s3_bucket" "backups" {
  bucket = "${var.staging_name}.${var.backup_primary_s3_bucket_name}"
}

variable "linode_region" {
  type      = string
  sensitive = true
}

variable "ansible_ssh_public_key" {
  type = string
}

resource "linode_instance" "server" {
  label           = "${var.staging_name}-jqc-server"
  tags            = ["staging"]
  image           = "linode/debian13"
  region          = var.linode_region
  type            = "g6-standard-2"
  authorized_keys = [var.ansible_ssh_public_key]
}
