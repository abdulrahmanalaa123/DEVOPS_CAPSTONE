variable "aws_region" {
	type = string
	default = "us-east-1"
}
variable "cred_profile"{
	type = string
	default = "default"
}


variable "vpc_cidr_block" {
    description = "The CIDER block for the VPC"
    type = string
  
}



variable private_subnet_cidr_blocks {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  # default     = []
}


variable public_subnet_cidr_blocks {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  # default     = []
}
module "namespace" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  
}