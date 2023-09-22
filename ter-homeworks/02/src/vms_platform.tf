###OS
variable "vm_web_family_name" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "version OS"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "platfom version"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "platfom version"
}

variable "vm_db_resource" {
  type = map
  default  = {
    cores  = 2
    memory = 2
    core_fraction = 20
  }
}

variable "vm_web_resource" {
  type = map
  default  = {
    cores  = 2
    memory = 1
    core_fraction = 20
  }
}