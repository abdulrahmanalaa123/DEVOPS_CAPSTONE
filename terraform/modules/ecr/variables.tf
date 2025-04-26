variable "vpc_id" {
    type = string
    default = "none"
}
variable "region" {
    type = string
    default = "none"
}
variable "sg_array" {
    type = list(any)
    default = [ ]
}

variable "cluster_role_name" {
  type = string
  default = "none"
}
variable "worker_role_name" {
  type = string
  default = "none"
}