resource "yandex_compute_instance" "forech_bm" {
  depends_on  = [yandex_compute_instance.web]
  for_each    = local.vm_foreach
  name        = each.key
  platform_id = var.vm_platform_id
  resources {
    cores         = each.value.cpu
    memory        = each.value.memory
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = "fd8tcjmhffpii4v6m09d"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    ssh-keys = local.ssh
  }
}
