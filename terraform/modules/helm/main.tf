resource "helm_release" "argocd" {
  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "3.35.4"

  values     = [file("../argo-cd/values.yaml")]
  depends_on = [var.cluster_name]
}

resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  namespace  = "jenkins"
  create_namespace = true
  version    = "5.8.37"  # You can adjust the version depending on your needs
  wait             = true
  values = [
    file("modules/helm/jenkins-values.yaml")

  ]
}


