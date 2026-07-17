# TFLint configuration file

plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

plugin "aws" {
    enabled = true
    version = "0.43.0"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
    # Attestation verification crashes tflint since GitHub removed the
    # `bundle` field from its API (terraform-linters/tflint#2591).
    signature = "pgp"
}
