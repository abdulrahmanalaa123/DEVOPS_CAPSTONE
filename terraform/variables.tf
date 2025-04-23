variable "aws_region" {
	type = string
	default = "us-east-1"
}
variable "cred_profile"{
	type = string
	default = "admin2"
}

variable "vpc_cidr" {
	type = string
	default = "10.0.0.0/16"
}

variable "cluster_name" {
	type = string
	default = "my-cluster"
}