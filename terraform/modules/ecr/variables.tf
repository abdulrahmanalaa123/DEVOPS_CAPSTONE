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