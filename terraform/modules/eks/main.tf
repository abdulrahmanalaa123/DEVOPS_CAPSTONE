resource "aws_eks_cluster" "cluster" {
  name    = var.cluster_name
  version = var.cluster_version
  vpc_config {
    subnet_ids = var.private_subnet_ids
  }
  role_arn = aws_iam_role.eks_role.arn
  depends_on = [aws_iam_role.eks_role,
  aws_iam_role_policy_attachment.eks_role_policy]

}
