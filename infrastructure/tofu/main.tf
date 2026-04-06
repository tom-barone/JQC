terraform {
  required_version = ">= 1.11.0, < 2.0.0"

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

provider "aws" {}

data "aws_region" "current" {}

locals {
  # TODO: When ready flip this back to use the actual prod domain.
  # domain_prefix = var.ENVIRONMENT == "production" ? "" : "${var.ENVIRONMENT}."
  domain_prefix = "${var.ENVIRONMENT}."
  subdomains = ["monitoring"]
}

