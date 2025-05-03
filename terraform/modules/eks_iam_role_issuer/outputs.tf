output "created_policies_list" {
  value = {for index, role in local.created_roles_list : role => local.issued_access_policies[index] } 
}