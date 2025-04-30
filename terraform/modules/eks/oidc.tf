# this gets the tls info about the cluster endpoint 
data "tls_certificate" "eks" {
  # which is specified by this attribute to get the proper link
  # this is the amazon provider which is called to get the proper 
  # authority using oidc
  # for example it could be accounts.google.com for the url
  # to get the specific permissions to authenticate as specific users using oidc
  url = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks_oidc" {
#   aws_eks_cluster.cluster.identity[0].oidc[0].issuer
  url = data.tls_certificate.eks.url
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
}
