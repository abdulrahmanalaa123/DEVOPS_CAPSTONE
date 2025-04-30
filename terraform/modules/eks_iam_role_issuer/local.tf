data "aws_caller_identity" "curr_user" {}

locals {
    oidc_provider = replace(var.oidc_url, "https://", "")
    current_account_id = data.aws_caller_identity.curr_user.account_id
}