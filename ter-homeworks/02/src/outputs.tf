output "vm_external_ip_address_web" {
value = yandex_compute_instance.platform1.network_interface[0].nat_ip_address
description = "vm external ip"
}

output "vm_external_ip_address_db" {
value = yandex_compute_instance.platform2.network_interface[0].nat_ip_address
description = "vm external ip"
}