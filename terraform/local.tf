data "aws_caller_identity" "curr_user" {}

locals {
  current_account_id = data.aws_caller_identity.curr_user.account_id
  principal_root_arn  = "arn:aws:iam::${data.aws_caller_identity.curr_user.account_id}:root"
}