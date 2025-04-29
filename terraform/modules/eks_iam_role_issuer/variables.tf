variable "service_accounts" {
    type = list(object({
      service_name = string
      namespace = string
      required_policy = object({
        Effect = string
        Actions = list(string)
        Resource = list(string)
      })
    }))
}

variable "oidc_url" {
  type = string
  default = "none"
}
variable "oidc_arn" {
  type = string
  default = "none"
}
