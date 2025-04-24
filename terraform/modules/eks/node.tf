resource "aws_eks_node_group" "private-node" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "private-node-group"
  node_role_arn   = aws_iam_role.node_group_role.arn
  subnet_ids      = var.private_subnet_ids
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  instance_types = ["t3.small"]
  capacity_type  = "ON_DEMAND"
  update_config {
    max_unavailable = 1
  }
}
