resource "aws_iam_user" "ses_smtp" {
  name = "${var.ENVIRONMENT}-ses-smtp"
}

resource "aws_iam_user_policy" "ses_smtp" {
  name = "${var.ENVIRONMENT}-ses-smtp"
  user = aws_iam_user.ses_smtp.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ses:SendEmail", "ses:SendRawEmail"]
        Resource = "arn:aws:ses:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:identity/${var.DOMAIN}"
      },
    ]
  })
}

resource "aws_iam_access_key" "ses_smtp" {
  user = aws_iam_user.ses_smtp.name
}
