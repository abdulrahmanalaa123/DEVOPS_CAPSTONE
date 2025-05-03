data "aws_caller_identity" "curr_user" {}

locals {
    oidc_provider = replace(var.oidc_url, "https://", "")
    current_account_id = data.aws_caller_identity.curr_user.account_id
    created_roles_list = [for role in aws_iam_role.roles_assignment : role.name]
    issued_access_policies = [for policy in data.aws_iam_policy_document.access_policies : policy.json]
}