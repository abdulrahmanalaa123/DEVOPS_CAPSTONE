output "cluster_name" {
  value = module.eks.cluster_name
}
output "region_name" {
  value = var.aws_region
}
output "account_id" {
  value = local.current_account_id
}

output "repos_links" {
  value = module.ecr.repos_links
}

output "created_policies" {
  value = module.eks_iam.created_policies
}