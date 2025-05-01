variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}
variable "namespace" {
  description = "Namespace where ArgoCD is installed"
  type        = string
  default     = "argocd"
}

variable "irsa_module_dependency" {
  description = "Dependency on the IRSA module to ensure IAM roles are created before Helm release"
  type        = any
}


variable "aws_region" {
	type = string
	default = "us-east-1"
}
