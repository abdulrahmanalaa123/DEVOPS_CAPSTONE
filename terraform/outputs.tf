output "cluster_name" {
  value = module.eks.cluster_name
}
output "region_name" {
  value = var.aws_region
}
output "account_id" {
  value = local.current_account_id
}