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

2. Создал в VPC публичную подсеть с названием public и сетью 192.168.10.0/24 согласно заданию:

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

Ресурсы и переменные можно посмотреть в файлах [network.tf](https://github.com/VladimirEremenko-web/devops-netology/blob/main/clopro-homeworks/01/src/network.tf) и [variables.tf](https://github.com/VladimirEremenko-web/devops-netology/blob/main/clopro-homeworks/01/src/variables.tf)

 - Создал в публичной подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использую fd80mrhj8fl2oe87o4e1. Код написан в файле [nat_instance.tf](https://github.com/VladimirEremenko-web/devops-netology/blob/main/clopro-homeworks/01/src/nat_instance.tf)

 - Создал в публичной подсети виртуальную машину с публичным IP. Код написан в файле [public.tf](https://github.com/VladimirEremenko-web/devops-netology/blob/main/clopro-homeworks/01/src/public.tf)

 - Подключаюсь к BM

  ![Ск](./images/connect%20to%20public%20BM.jpg)

 - Проверяю доступность yandex.ru

  ![Ск](./images/ping%20ya%20with%20public%20BM.jpg)

>Интернет на публичной виртуальной машине есть.

3. Создал в VPC приватную подсеть с названием private и сетью 192.168.20.0/24 согласно заданию:

```
resource "yandex_vpc_subnet" "private" {
  name           = var.private_subnet
  zone           = var.default_zone
  network_id     = yandex_vpc_network.dvl.id
  v4_cidr_blocks = var.private_cidr
  route_table_id = yandex_vpc_route_table.private-route.id
}

variable "private_cidr" {
  type        = list(string)
  default     = ["192.168.20.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "private_subnet" {
  type        = string
  default     = "private"
  description = "subnet name"
}
```

 - Так же создаю `route table`. Добавляю статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс:

 ```
resource "yandex_vpc_route_table" "private-route" {
  name       = "private-route"
  network_id = yandex_vpc_network.dvl.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.254"
  }
}
 ```
Конфигурация размещена в файлах [network.tf](https://github.com/VladimirEremenko-web/devops-netology/blob/main/clopro-homeworks/01/src/network.tf) и [variables.tf](https://github.com/VladimirEremenko-web/devops-netology/blob/main/clopro-homeworks/01/src/variables.tf)

 - В приватной подсети создал виртуальную машину с внутренним IP без внешнего.

 Код описан в файле [private.tf](https://github.com/VladimirEremenko-web/devops-netology/blob/main/clopro-homeworks/01/src/private.tf)

 - Чтобы проверить доступность интернета на приватной виртуальной машине и работы NAT-инстанса скопировал свой приватный ssh-ключ на публичную виртуальную машину и с неё подключился к приватной по внутреннему IP адресу:

 ![as](./images/copy%20private%20key%20to%20public%20BM.jpg)

 ![as](./images/ping%20yandex%20with%20private%20BM.jpg)

Хост пингуется - интернет на приватной BM есть.

 - Для проверки работоспособности конфигураций выключил NAT BM и проверяю доступность `yandex.ru`

 ![as](./images/ping%20ya%20with%20stopped%20nat%20BM.jpg)

 > Адрес не пингуется, соответственно конфигурация рабочая.

 Общий перечень BM в облаке:

 ![as](./images/BM%20list.jpg)

 ----

Все манифесты размещены в [каталоге](https://github.com/VladimirEremenko-web/devops-netology/tree/main/clopro-homeworks/01/src)
