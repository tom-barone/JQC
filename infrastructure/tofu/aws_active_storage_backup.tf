resource "aws_s3_bucket" "restic_active_storage_backups" {
  bucket        = "${var.ENVIRONMENT}.restic-active-storage-backups.${var.DOMAIN}"
  force_destroy = var.ENVIRONMENT != "production"
}

resource "aws_iam_user" "restic_active_storage_backups" {
  name = "${var.ENVIRONMENT}-restic-active-storage-backups"
}

# User with permissions to read/write to the S3 bucket for restic active storage backups
resource "aws_iam_user_policy" "restic_active_storage_backups" {
  name = "${var.ENVIRONMENT}-restic-active-storage-backups"
  user = aws_iam_user.restic_active_storage_backups.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
        ]
        Resource = aws_s3_bucket.restic_active_storage_backups.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
        ]
        Resource = "${aws_s3_bucket.restic_active_storage_backups.arn}/*"
      },
    ]
  })
}

resource "aws_iam_access_key" "restic_active_storage_backups" {
  user = aws_iam_user.restic_active_storage_backups.name
}
