provider "aws" {}

data "aws_region" "current" {}

resource "aws_s3_bucket" "restic_postgres_backups" {
  bucket        = "${var.ENVIRONMENT}.restic-postgres-backups.${var.DOMAIN}"
  force_destroy = var.ENVIRONMENT != "production"
}

resource "aws_iam_user" "restic_postgres_backups" {
  name = "${var.ENVIRONMENT}-restic-postgres-backups"
}

# User with permissions to read/write to the S3 bucket for restic postgres backups
resource "aws_iam_user_policy" "restic_postgres_backups" {
  name = "${var.ENVIRONMENT}-restic-postgres-backups"
  user = aws_iam_user.restic_postgres_backups.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
        ]
        Resource = aws_s3_bucket.restic_postgres_backups.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
        ]
        Resource = "${aws_s3_bucket.restic_postgres_backups.arn}/*"
      },
    ]
  })
}

resource "aws_iam_access_key" "restic_postgres_backups" {
  user = aws_iam_user.restic_postgres_backups.name
}

data "aws_route53_zone" "domain" {
  name = local.domain
}

resource "aws_route53_record" "domain" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "${local.domain_prefix}${local.domain}"
  type    = "A"
  ttl     = 300
  records = [one(linode_instance.server.ipv4)]
}

resource "aws_route53_record" "subdomains" {
  for_each = toset(local.subdomains)

  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "${local.domain_prefix}${each.value}.${local.domain}"
  type    = "A"
  ttl     = 300
  records = [one(linode_instance.server.ipv4)]
}
