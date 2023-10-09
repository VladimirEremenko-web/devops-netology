###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "vm_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "platfom version"
}
/*variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCxVfgHVEdJEIJgWSU0ljvQuZ5DTRHGZ9GSH5qLHoZ4378GoqfgVhjQlrMWeXNLiSHicA8G9wNlqbTcfd65RlG1VvEb9Gpj3p1vgH+gQ/+Bq8x12zcZZz7+hb30+fq3BLEsXCum2AWXb6ox9Fi7qaUiBHkocbTBFOoQl771t2BgU4yZWfet2I2SVK3HRIXqPoVoBMRbRKHlmid8HAoppeswcrbfjcpq3RPk8SkiciPeuIAU1htPfaUiHgAg0hK2GvPm4JCbodcj2yMBYjFmJWFEvGP6p9691XMn0o34AfJ4H9hw+CGTK+kiMulevAkndewy90cMuZslJ3K+b9dMaumcwfEhksY6xbFb4SX/HwS7DF38Mzawq1AHAYj9qQg3C484K77EewdW0OW8joEdsRyGfF2O3JkTL3C5TvbeaK8IhZZB9+nk66lb/TarT6SlpfmSaN0XpjSMnmxJVW3h1hfooeZmewiWS5MwRqqVy3OV4kCfFD55eqFFlOiMbS8lqCM= lanc1k@lanc1k-VirtualBox"
  description = "ssh-keygen -t ed25519"
}*/

