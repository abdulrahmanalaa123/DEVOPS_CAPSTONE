variable "aws_region" {
	type = string
	default = "us-east-1"
}
variable "cred_profile"{
	type = string
	default = "default"
}


variable "vpc_cider" {
    description = "The CIDER block for the VPC"
    type = string
  
}