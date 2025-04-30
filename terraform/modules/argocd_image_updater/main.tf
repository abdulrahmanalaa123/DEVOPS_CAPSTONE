resource "helm_release" "argocd_image_updater" {
  name             = "argocd-image-updater"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-image-updater"
  namespace        = var.namespace
  create_namespace = false
  version          = "0.11.0"
  values           = [file("${path.module}/values/image-updater.yaml")]

  depends_on = [var.irsa_module_dependency]
}
