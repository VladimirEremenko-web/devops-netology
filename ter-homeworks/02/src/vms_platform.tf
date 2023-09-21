###OS
variable "vm_web_family_name" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "version OS"
}
###BM 1

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "platfom version"
}


###BM 2

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "platfom version"
}


variable "resources_db" {
  type = map
  default  = {
    cores  = 2
    memory = 2
    core_fraction = 20
  }
}

variable "resources_web" {
  type = map
  default  = {
    cores  = 2
    memory = 1
    core_fraction = 20
  }
}