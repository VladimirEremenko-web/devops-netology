resource "yandex_compute_disk" "disks" {
  count = 3
  name  = "disk-${count.index + 1}"
  size  = 1
}
resource "yandex_compute_instance" "storage" {
  name = local.vm_storage_name
  resources {
    cores         = var.resources_storage["cores"]
    memory        = var.resources_storage["memory"]
    core_fraction = var.resources_storage["core_fraction"]
  }
  boot_disk {
    initialize_params {
      image_id = var.boot_images
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
