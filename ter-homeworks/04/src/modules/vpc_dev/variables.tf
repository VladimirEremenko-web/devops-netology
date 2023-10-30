variable "env_name" {
  type        = string
  description = "VPC net&subnet"
}

variable "v4_cidr_blocks" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}

variable "zone" {
  type    = string
  default = ""
}
