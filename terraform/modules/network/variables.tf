variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "first_pb_subnet_cidr" {
  description = "CIDR block for the first public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "first-AZ" {
  description = "First Availability zone"
  type        = string
  default     = "us-east-1a"
  
}

variable "second-pb-subnet-cidr" {
  description = "CIDR block for the second public subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "Second-AZ" {
  description = "First Availability zone"
  type        = string
  default     = "us-east-1b"
}

variable "third-pb-subnet-cidr" {
  description = "CIDR block for the third public subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "third-AZ" {
  description = "First Availability zone"
  type        = string
  default     = "us-east-1c"
}

variable "First-pv-subnet-cidr" {
  description = "CIDR block for the first private subnet"
  type        = string
  default     = "10.0.4.0/24"
}

variable "Second-pv-subnet-cidr" {
  description = "CIDR block for the second private subnet"
  type        = string
  default     = "10.0.5.0/24"
  
}

variable "Third-pv-subnet-cidr" {
  description = "CIDR block for the third private subnet"
  type        = string
  default     = "10.0.6.0/24"
  
}