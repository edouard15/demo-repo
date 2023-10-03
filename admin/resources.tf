provider "vault" {
  address = var.vault_addr
  token   = var.vault_token

}

resource "vault_aws_secret_backend" "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "us-west-2"

  default_lease_ttl_seconds = "120"
  max_lease_ttl_seconds     = "3600"

}

resource "vault_aws_secret_backend_role" "role" {
  backend         = vault_aws_secret_backend.aws.path
  name            = "ec2-admin-role"
  credential_type = "iam_user"

  policy_document = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow", 
      "Action": [
        "ec2:*", "eks:*", "iam:*"

      ],
      "Resource": "*"
    }
  ]
}
EOT
}

resource "vault_auth_backend" "aws" {
  type = "aws"
}

#use this a role if you dont use access and scret key
resource "vault_aws_auth_backend_sts_role" "role" {
  backend    = vault_auth_backend.aws.path
  account_id = "1234567890"
  sts_role   = "arn:aws:iam::1234567890:role/my-role"
}