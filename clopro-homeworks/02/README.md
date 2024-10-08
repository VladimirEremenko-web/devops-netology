# Домашнее задание к занятию «Вычислительные мощности. Балансировщики нагрузки»

### Задание 1. Yandex Cloud

**Что нужно сделать**

1. Создать бакет Object Storage и разместить в нём файл с картинкой:
 - Создать бакет в Object Storage с произвольным именем (например, имя_студента_дата).
 - Положить в бакет файл с картинкой.
 - Сделать файл доступным из интернета.
2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на картинку из бакета:
 - Создать Instance Group с тремя ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать image_id = `fd827b91d99psvq5fjit`.
 - Для создания стартовой веб-страницы рекомендуется использовать раздел user_data в meta_data.
 - Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из бакета.
 - Настроить проверку состояния ВМ.
3. Подключить группу к сетевому балансировщику:
 - Создать сетевой балансировщик.
 - Проверить работоспособность, удалив одну или несколько ВМ.
4. (дополнительно)* Создать Application Load Balancer с использованием Instance group и проверкой состояния.

----

**Выполнение.**

1. Создаю бакет в Object Storage с моими инициалами и текущей датой:

```
// Создаем сервисный аккаунт для backet
resource "yandex_iam_service_account" "service" {
  folder_id = var.folder_id
  name      = "bucket-sa"
}

// Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "bucket-editor" {
  folder_id  = var.folder_id
  role       = "storage.editor"
  member     = "serviceAccount:${yandex_iam_service_account.service.id}"
  depends_on = [yandex_iam_service_account.service]
}

// Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.service.id
  description        = "static access key for object storage"
}

// Создание бакета с использованием ключа
resource "yandex_storage_bucket" "eremenko" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = local.bucket_name
  acl        = "public-read"
}
```
За текущую дату в названии бакета будет отвечать локальная переменная `current_timestamp` в формате "день-месяц-год" и моя фамилия:

```
locals {
    current_timestamp = timestamp()
    formatted_date = formatdate("DD-MM-YYYY", local.current_timestamp)
    bucket_name = "eremenko-${local.formatted_date}"
}
```

Код создания bucket в файле [bucket.tf](https://github.com/VladimirEremenko-web/devops-netology/blob/main/clopro-homeworks/02/src/bucket.tf)

Загружу в бакет файл с картинкой:

```
resource "yandex_storage_object" "picture" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = local.bucket_name
  key        = "picture.jpg"
  source     = "~/picture.jpg"
  acl        = "public-read"
  depends_on = [yandex_storage_bucket.eremenko]
}
```

Источником картинки будет файл, лежащий в моей домашней директории, за публичность картинки будет отвечать параметр `acl = "public-read"`.

Код Terraform для загрузки картинки можно посмотреть в файле [upload_image.tf](https://github.com/VladimirEremenko-web/devops-netology/blob/main/clopro-homeworks/02/src/upload_image.tf)

2. Создаю группу ВМ в `public` подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на картинку из бакета.

```
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "public_subnet" {
  type        = string
  default     = "public-subnet"
  description = "subnet name"
}

resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public" {
  name           = var.public_subnet
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}
```

За шаблон виртуальных машин с LAMP будет отвечать переменная в группе виртуальных машин `image_id = "fd827b91d99psvq5fjit"`.

За создание стартовой веб-страницы будет отвечать параметр `user_data` в разделе `metadata`:

```
user-data  = <<EOF
#!/bin/bash
cd /var/www/html
echo '<html><head><title>Rofl picture</title></head> <body><h1>Heh</h1><img src="http://${yandex_storage_bucket.eremenko.bucket_domain_name}/picture.jpg"/></body></html>' > index.html
EOF
```

За проверку состояния виртуальной машины будет отвечать код:

```
  health_check {
    interval = 30
    timeout  = 10
    tcp_options {
      port = 80
    }
  }
```

Проверка здоровья будет выполняться каждые 30 секунд и будет считаться успешной, если подключение к порту 80 виртуальной машины происходит успешно в течении 10 секунд.

Код для создания группы виртуальных машин можно посмотреть в файле [group_vm.tf](https://github.com/VladimirEremenko-web/devops-netology/blob/main/clopro-homeworks/02/src/group_vm.tf)

Получаем три настроенные по шаблону LAMP виртуальные машины:

3. Создам сетевой балансировщик и подключаем к нему группу виртуальных машин:

```
resource "yandex_lb_network_load_balancer" "network-balancer" {
  name = "lamp-balancer"
  deletion_protection = "false"
  listener {
    name = "http-check"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = yandex_compute_instance_group.group-vms.load_balancer[0].target_group_id
    healthcheck {
      name = "http"
      interval = 2
      timeout = 1
      unhealthy_threshold = 2
      healthy_threshold = 5
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}
```

Балансировщик нагрузки будет проверять доступность порта 80 и путь "/" при обращении к целевой группе виртуальных машин. Проверка будет выполняться с интервалом 2 секунды, с таймаутом 1 секунда. Пороговые значения для определения состояния сервера будут следующими: 2 неудачные проверки для перевода сервера LAMP в недоступное состояние и 5 успешных проверок для возврата в доступное состояние.

Проверю статус балансировщика нагрузки и подключенной к нему группе виртуальных машин после применения кода:

![as](./images/state%20load%20balancer%20network.jpg)

>Балансировщик нагрузки создан и активен, подключенные к нему виртуальные машины в статусе "HEALTHY".

Проверю доступность сайта через балансировщик нагрузки, открыв его внешний ip-адрес. 

![as](./images/ip%20load%20balancer.jpg)

Через IP-адрес балансировщика нагрузки я попадаю на созданную мной страницу:

![as](./images/check%20rofl%20picture.jpg)

>Балансировщик нагрузки работает.

Проверю доступность сайта, если отключить пару виртуальных машин

![as](./images/stopped%202%20bm.jpg)

Сайт всё равно доступен через ip балансировщика 

![as](./images/site%20on.jpg)

Через некоторое время благодаря срабатыванию Healthcheck виртуальные машины снова запустились, что обеспечивает нам высокую отказоустойчивость приложления.

Код для создания сетевого балансировщика в файле [network_load_balancer.tf](https://github.com/VladimirEremenko-web/devops-netology/blob/main/clopro-homeworks/02/src/network_load_balancer.tf)

----

Все манифесты размещены в [каталоге](https://github.com/VladimirEremenko-web/devops-netology/tree/main/clopro-homeworks/02/src)