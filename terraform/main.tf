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

module "network" {
  source = "./modules/network"
  vpc_cidr = var.vpc_cidr
}