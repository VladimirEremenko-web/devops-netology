variable "env_name" {
  type        = string
  description = "VPC net&subnet"
}

variable "subnets" {
  type = list(object({
    zone = string,
    cidr = string
  }))
}
