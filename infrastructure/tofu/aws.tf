provider "aws" {}

resource "aws_s3_bucket" "backups" {
  bucket = "${var.ENVIRONMENT}.${var.BACKUP_PRIMARY_S3_BUCKET_NAME}"
}
