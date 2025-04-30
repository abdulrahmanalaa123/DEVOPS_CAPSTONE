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
module "ecr" {
  source = "./modules/ecr"
  region = var.aws_region
  cluster_role_name = module.eks.cluster_role.name
  cluster_role_arn = module.eks.cluster_role.arn
  worker_role_name =  module.eks.worker_role.name
  worker_role_arn =  module.eks.worker_role.arn
  depends_on = [ data.aws_eks_cluster_auth.cluster ]
}

# the role's naming convention is named by eks_${service_name}
# so when creating a service account make sure to add
# The Amazon EKS Pod Identity Webhook on the cluster watches for Pods that use a service account with the following annotation:
#   name: ${service_name}
#   annotations:
#    eks.amazonaws.com/role-arn: arn:aws:iam::[AWS account ID]:role/eks_${service_name}
module "eks_iam" {
  source = "./modules/eks_iam_role_issuer"
  oidc_arn = module.eks.oidc_provider.arn
  oidc_url = module.eks.oidc_provider.url
  # https://www.awsiamactions.io/generator
  service_accounts = [
    {
     service_name = "jenkins"
     namespace = "jenkins"
     required_policy = {
        Effect = "Allow"
        Actions = [    
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:Encrypt"
          ]
        Resources = ["*"]
        } 
    },

    {
      service_name    = "argocd-image-updater",
      namespace       = "argocd",
      required_policy = {
        Effect = "Allow",
        Actions = [
          "ecr:DescribeImages",
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "kms:Decrypt",
          "kms:DescribeKey"
        ],
        Resources = ["*"]
      
      }
    }
  ]
  
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
      kubectl apply -f ../argo-cd/argocd-manifests/argocd.yaml
    EOT
  }
}



module "argocd_image_updater" {
  source                = "./modules/argocd-image-updater"
  namespace             = "argocd"
  irsa_module_dependency = module.eks_iam
}
