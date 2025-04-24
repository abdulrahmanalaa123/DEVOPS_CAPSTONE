terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
  profile = var.cred_profile
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  }
  
}

module "network" {
  source = "./modules/network"
  vpc_cidr = var.vpc_cidr
}
module "eks" {
  source = "./modules/eks"
  cluster_name = var.cluster_name
  private_subnet_ids = module.network.private_subnet_ids

}
module "helm" {
  source = "./modules/helm"
  cluster_name = module.eks.cluster_name
}

resource "null_resource" "apply_argocd_root_application" {
  depends_on = [
    module.helm.argocd
  ]

  provisioner "local-exec" {
    command = <<-EOT
      aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_region}
      kubectl apply -f ../argo-cd/argocd.yaml
    EOT
  }
}