resource "aws_eks_node_group" "private-jenkins" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "private-jenkins-node-group"
  node_role_arn   = aws_iam_role.node_group_role.arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]
  disk_size      = 50
  capacity_type  = "ON_DEMAND"

  labels = {
    kubernetes.io/hostname = "jenkins-node"
  }
  update_config {
    max_unavailable = 1
  }
}

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

  instance_types = ["t3.medium"]
  disk_size      = 20
  capacity_type  = "ON_DEMAND"
  labels = {
    kubernetes.io/hostname = "Application"
  }

  update_config {
    max_unavailable = 1
  }
}
