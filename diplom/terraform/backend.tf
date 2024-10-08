terraform {
  backend "s3" {
    endpoint                    = "storage.yandexcloud.net"
    bucket                      = "lanc1k-state"
    region                      = "ru-central1"
    key                         = "lanc1k-state/terraform.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
