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

variable "repo_list" {
  type= list(string)
  default = [ "az3_app", "az3_app_chart", "az3_jenkins_chart", "az3_argo_chart"]
}
variable "cluster_role_name" {
  type = string
  default = "none"
}
variable "cluster_role_arn" {
  type = string
  default = "none"
}
variable "worker_role_name" {
  type = string
  default = "none"
}
variable "worker_role_arn" {
  type = string
  default = "none"
}