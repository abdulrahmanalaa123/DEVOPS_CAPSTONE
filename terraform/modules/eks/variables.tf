variable "cluster_name" {
    description = "The name of the EKS cluster"
    type        = string
}
variable "cluster_version" {
    description = "The version of the EKS cluster"
    type        = string
    default     = "1.32"
}

variable "private_subnet_ids" {
    description = "List of private subnet IDs for the EKS cluster"
    type        = list(string)
}