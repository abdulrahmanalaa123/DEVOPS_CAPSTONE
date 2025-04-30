output "argocd_image_updater_release_name" {
  description = "Name of the ArgoCD Image Updater Helm release"
  value       = helm_release.argocd_image_updater.name
}
