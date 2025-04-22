variable "aws_region" {
	type = string
	default = "us-east-1"
}
variable "cred_profile"{
	type = string
	default = "default"
}

variable vpc_cidr_block {}
variable private_subnet_cidr_blocks {}
variable public_subnet_cidr_blocks {}