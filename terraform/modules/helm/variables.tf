variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "irsa_module_dependency" {
  description = "Dependency on the IRSA module to ensure IAM roles are created before Helm release"
  type        = any
}


variable "aws_region" {
	type = string
	default = "us-east-1"
}
variable "private_node_group_name" {
  description = "The name of the private node group"
  type        = string
}