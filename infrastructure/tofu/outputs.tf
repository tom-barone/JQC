output "JQC_SERVER_IP_ADDRESS" {
  value     = one(linode_instance.server.ipv4)
  sensitive = true
}

output "JQC_HOSTNAME" {
  value     = "${local.domain_prefix}${var.DOMAIN}"
  sensitive = true
}

output "JQC_HOSTNAME_MONITORING" {
  value     = "${local.domain_prefix}monitoring.${var.DOMAIN}"
  sensitive = true
}

output "RESTIC_POSTGRES_S3_BUCKET" {
  value     = aws_s3_bucket.restic_postgres_backups.bucket
  sensitive = true
}

output "RESTIC_POSTGRES_S3_ENDPOINT" {
  value     = "s3.${data.aws_region.current.id}.amazonaws.com"
  sensitive = true
}

output "RESTIC_POSTGRES_S3_ACCESS_KEY" {
  value     = aws_iam_access_key.restic_postgres_backups.id
  sensitive = true
}

output "RESTIC_POSTGRES_S3_SECRET_KEY" {
  value     = aws_iam_access_key.restic_postgres_backups.secret
  sensitive = true
}

output "RESTIC_ACTIVE_STORAGE_S3_BUCKET" {
  value     = aws_s3_bucket.restic_active_storage_backups.bucket
  sensitive = true
}

output "RESTIC_ACTIVE_STORAGE_S3_ENDPOINT" {
  value     = "s3.${data.aws_region.current.id}.amazonaws.com"
  sensitive = true
}

output "RESTIC_ACTIVE_STORAGE_S3_ACCESS_KEY" {
  value     = aws_iam_access_key.restic_active_storage_backups.id
  sensitive = true
}

output "RESTIC_ACTIVE_STORAGE_S3_SECRET_KEY" {
  value     = aws_iam_access_key.restic_active_storage_backups.secret
  sensitive = true
}

output "SMTP_RELAY_HOST" {
  value     = "email-smtp.${data.aws_region.current.id}.amazonaws.com"
  sensitive = true
}

output "SMTP_RELAY_PORT" {
  value     = "2587"
  sensitive = true
}

output "SMTP_RELAY_USERNAME" {
  value     = aws_iam_access_key.ses_smtp.id
  sensitive = true
}

output "SMTP_RELAY_PASSWORD" {
  value     = aws_iam_access_key.ses_smtp.ses_smtp_password_v4
  sensitive = true
}
