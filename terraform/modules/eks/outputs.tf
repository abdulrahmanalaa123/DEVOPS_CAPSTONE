output "cluster_name" {
  value = aws_eks_cluster.cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}
output "cluster_role" {
  value = aws_iam_role.eks_role
}
output "worker_role" {
  value = aws_iam_role.node_group_role
}

output "private_node_group_name" {
  value = aws_eks_node_group.private-node.node_group_name
}
