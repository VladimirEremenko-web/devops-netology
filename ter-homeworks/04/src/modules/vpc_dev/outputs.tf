output "yandex_vpc_network" {
  value       = yandex_vpc_network.network
  description = "VPC network"
}

output "yandex_vpc_subnet" {
  value       = yandex_vpc_subnet.subnet
  description = "VPC subnet"
}
