terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region 
  shared_credentials_files = ["$HOME/.aws/credentials"]
  profile = var.cred_profile
}

module "network" {
  source = "./modules/network"
  vpc_cider = var.vpc_cider

}