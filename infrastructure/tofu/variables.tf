variable "OPENTOFU_STATE_ENCRYPTION_PASSWORD" {
  type      = string
  sensitive = true
}

variable "ENVIRONMENT" {
  type = string
}

variable "LINODE_REGION" {
  type      = string
  sensitive = true
}

variable "ANSIBLE_SSH_PUBLIC_KEY" {
  type      = string
  sensitive = true
}

variable "DOMAIN" {
  type      = string
  sensitive = true
}
