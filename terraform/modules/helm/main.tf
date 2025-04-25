
resource "helm_release" "argocd" {
  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "3.35.4"

  values = [file("../argo-cd/values.yaml")]
  depends_on = [var.cluster_name]
}

resource "helm_release" "mysql" {
  name       = "my-mysql"
  namespace  = "default"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mysql"

  values = [
    file("helm/mysql-values.yaml")
  ]
}

resource "helm_release" "redis" {
  name       = "my-redis"
  namespace  = "default"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"

  values = [
    file("helm/redis-values.yaml")
  ]
}

