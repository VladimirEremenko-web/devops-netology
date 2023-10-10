locals {
  vm_foreach = {
    "main" = {
      cpu           = 2
      memory        = 2
      core_fraction = 50
    },
    "replica" = {
      cpu           = 4
      memory        = 4
      core_fraction = 20
    }
  }
  vm_storage_name = "storage"
}

locals {
  ssh = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
}
