data "aws_iam_policy_document" "access_policies" {
  for_each = { for index, service in var.service_accounts : service.service_name => service }
    
  statement {
    effect = each.value.required_policy.Effect
    actions = each.value.required_policy.Actions
    resources = each.value.required_policy.Resources
  }
}
resource "aws_iam_policy" "service_policies" {
  for_each = { for index, service in var.service_accounts : service.service_name => service }
  policy = data.aws_iam_policy_document.access_policies[each.key].json
}
resource "aws_iam_role_policy_attachment" "roles_access" {
  for_each = { for index, service in var.service_accounts : service.service_name => service }
  role = aws_iam_role.roles_assignment[each.key].name
  policy_arn = aws_iam_policy.service_policies[each.key].arn
}