output "created_roles_list" {
  value = [ for role in aws_iam_role.roles_assignment : role.name ] 
}
output "issued_access_policies" {
  value = [for policy in data.aws_iam_policy_document.access_policies : policy.json ] 
}