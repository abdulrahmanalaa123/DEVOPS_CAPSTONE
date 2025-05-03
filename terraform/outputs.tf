output "cluster_name" {
  value = module.eks.cluster_name
}
output "region_name" {
  value = var.aws_region
}
output "account_id" {
  value = local.current_account_id
}
output "created_roles_list" {
  value = module.eks_iam.created_policies_list
}

output "registries_urls" {
  value = module.ecr.registries_urls
}