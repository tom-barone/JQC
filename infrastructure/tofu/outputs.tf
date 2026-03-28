output "JQC_SERVER_IP_ADDRESS" {
  value     = one(linode_instance.server.ipv4)
  sensitive = true
}

output "JQC_HOSTNAME" {
  value     = "${local.domain_prefix}${local.domain}"
  sensitive = true
}

output "JQC_HOSTNAME_MONITORING" {
  value     = "${local.domain_prefix}monitoring.${local.domain}"
  sensitive = true
}

output "RESTIC_POSTGRES_S3_BUCKET" {
  value     = aws_s3_bucket.restic_postgres_backups.bucket
  sensitive = true
}

output "RESTIC_POSTGRES_S3_ENDPOINT" {
  value     = "s3.${data.aws_region.current.name}.amazonaws.com"
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
