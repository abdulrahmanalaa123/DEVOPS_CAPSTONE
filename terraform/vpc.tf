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



# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
  
  tags = {
    Name = "MyVPC"
  }
}


data "aws_availability_zones" "azs" {
  # count = 3
  # state = "available"
  # filter {
  #   name   = "region-name"
  #   values = [var.aws_region]
  # }

}


module "myapp-vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "myapp-vpc"
  cidr = var.vpc_cidr_block
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets = var.public_subnet_cidr_blocks
  azs = data.aws_availability_zones.azs.names


  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = true

  tags = {

    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/elb" = 1
  }
  
  private_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
  
}