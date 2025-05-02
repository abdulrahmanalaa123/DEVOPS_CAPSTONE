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
     service_name = "jenkins-admin"
     namespace = "jenkins"
     required_policy = {
        Effect = "Allow"
        Actions = [    
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:BatchGetImage",
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
    },
    {
      service_name = "aws-load-balancer-controller",
      namespace = "kube-system",
      required_policy = {
        Effect = "Allow",
        Actions = [
          "acm:DescribeCertificate",
          "acm:ListCertificates",
          "acm:ListTagsForCertificate",
          "ec2:DescribeAccountAttributes",
          "ec2:DescribeAddresses",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs",
          "elasticloadbalancing:AddListenerCertificates",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateRule",
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:DeleteRule",
          "elasticloadbalancing:DeleteTargetGroup",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:DescribeListenerCertificates",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeLoadBalancerAttributes",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeLoadBalancerPolicies",
          "elasticloadbalancing:DescribeRules",
          "elasticloadbalancing:DescribeSSLPolicies",
          "elasticloadbalancing:DescribeTags",
          "elasticloadbalancing:DescribeTargetGroupAttributes",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:GetLoadBalancerPolicyConfiguration",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:RemoveListenerCertificates",
          "elasticloadbalancing:RemoveTags",
          "elasticloadbalancing:SetIpAddressType ",
          "elasticloadbalancing:SetLoadBalancerAccessLogsStatus ",
          "elasticloadbalancing:SetLoadBalancerListenerSSLCertificate ",
          "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer ",
          "elasticloadbalancing:SetLoadBalancerPoliciesOfListener ",
        ],
        Resources = ["*"]
      }
    }
  ]
  
}



module "helm" {
  source = "./modules/helm"
  cluster_name = module.eks.cluster_name
  irsa_module_dependency = module.eks_iam
  aws_region = var.aws_region
  private_node_group_name = module.eks.private_node_group_name

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

