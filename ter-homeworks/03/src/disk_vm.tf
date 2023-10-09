resource "yandex_compute_disk" "disks" {
  count = 3
  name  = "disk-${count.index + 1}"
  size  = 1
}

resource "yandex_compute_instance" "storage" {
  name = "storage"
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8tcjmhffpii4v6m09d"
    }
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.disks.*.id
    content {
      disk_id = yandex_compute_disk.disks["${secondary_disk.key}"].id
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
