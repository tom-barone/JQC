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
  }
}

provider "aws" {}

variable "backup_primary_s3_bucket_name" {
  type      = string
  sensitive = true
}

resource "aws_s3_bucket" "backups" {
  bucket = var.backup_primary_s3_bucket_name
}
