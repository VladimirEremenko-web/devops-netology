resource "yandex_compute_instance" "web" {
  count = 2
  name  = "develop-web-${count.index + 1}"
  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
  boot_disk {
    initialize_params {
      image_id = "fd8tcjmhffpii4v6m09d"
    }
  }
  # scheduling_policy {
  #   preemptible = true
  # }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  metadata = {
    ssh-keys = local.ssh
  }
}
