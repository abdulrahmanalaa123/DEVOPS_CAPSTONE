data "aws_iam_policy_document" "trust_policies" {
  for_each = { for index, service in var.service_accounts : service.service_name => service }
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type = "Federated"
      identifiers = [var.oidc_arn]
    }
    condition {
      test = "StringEquals"
      variable = "${local.oidc_provider}:sub"
      values = ["system:serviceaccount:${each.value.namespace}:${each.key}"] 
    }
    condition {
      test = "StringEquals"
      variable = "${local.oidc_provider}:aud"
      values = ["sts.amazonaws.com" ]
    }
  }
}

resource "aws_iam_role" "roles_assignment" {
  for_each = { for index, service in var.service_accounts : service.service_name => service }
  assume_role_policy = data.aws_iam_policy_document.trust_policies[each.key].json
  name = "eks_${each.key}"
}
