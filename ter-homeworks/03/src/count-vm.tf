resource "yandex_compute_instance" "web" {
  count = 2
  name  = "develop-web-${count.index + 1}"
  resources {
    cores         = var.resources_count["cores"]
    memory        = var.resources_count["memory"]
    core_fraction = var.resources_count["core_fraction"]
  }
  boot_disk {
    initialize_params {
      image_id = var.boot_images
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
