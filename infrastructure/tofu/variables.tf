variable "OPENTOFU_STATE_ENCRYPTION_PASSWORD" {
  type      = string
  sensitive = true
}

variable "ENVIRONMENT" {
  type = string
}

variable "BACKUP_PRIMARY_S3_BUCKET_NAME" {
  type      = string
  sensitive = true
}

variable "LINODE_REGION" {
  type      = string
  sensitive = true
}

variable "ANSIBLE_SSH_PUBLIC_KEY" {
  type = string
}
