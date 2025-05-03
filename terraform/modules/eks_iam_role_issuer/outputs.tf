output "created_policies" {
  value = {for index, val in local.created_roles_list: val => local.issued_access_policies[index]}
}
