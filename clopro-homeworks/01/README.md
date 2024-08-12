# Домашнее задание к занятию «Организация сети»

### Задание 1. Yandex Cloud
Что нужно сделать

1. Создать пустую VPC. Выбрать зону.
2. Публичная подсеть.
 - Создать в VPC subnet с названием public, сетью 192.168.10.0/24.
 - Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1.
 - Создать в этой публичной подсети виртуалку с публичным IP, подключиться к ней и убедиться, что есть доступ к интернету.
3. Приватная подсеть.
 - Создать в VPC subnet с названием private, сетью 192.168.20.0/24.
 - Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс.
 - Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее, и убедиться, что есть доступ к интернету.

----

**Выполнение.**

1. Создал пустую VPC с именем lanc

```
resource "yandex_vpc_network" "lanc" {
  name = var.vpc_name

variable "vpc_name" {
  type        = string
  default     = "lanc"
  description = "VPC network"
}
```

2. Создал в VPC публичную подсеть с названием public, сетью 192.168.10.0/24:

```
resource "yandex_vpc_subnet" "public" {
  name           = var.public_subnet
  zone           = var.default_zone
  network_id     = yandex_vpc_network.lanc.id
  v4_cidr_blocks = var.public_cidr
}

variable "public_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "public_subnet" {
  type        = string
  default     = "public"
  description = "subnet name"
}
```

Ресурсы и переменные можно посмотреть в файлах network.tf и variables.tf

 - Создал в публичной подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использую fd80mrhj8fl2oe87o4e1. Код написан в файле nat_instance.tf

 
