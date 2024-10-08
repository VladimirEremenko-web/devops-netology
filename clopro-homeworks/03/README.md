# Домашнее задание к занятию «Безопасность в облачных провайдерах»

### Задание 1. Yandex Cloud

1. С помощью ключа в KMS необходимо зашифровать содержимое бакета:
 - создать ключ в KMS;
 - с помощью ключа зашифровать содержимое бакета, созданного ранее.
2. (Выполняется не в Terraform)* Создать статический сайт в Object Storage c собственным публичным адресом и сделать доступным по HTTPS:
 - создать сертификат;
 - создать статическую страницу в Object Storage и применить сертификат HTTPS;
 - в качестве результата предоставить скриншот на страницу с сертификатом в заголовке (замочек).

 ----

 **Выполнение**

 1. Чтобы выполнить задания использую код Terraform, выполненный в прошлом задании, т.к. в нем уже есть бакет и загрузка изображения в него.

 Создал роль для службы KMS, которая даст возможность зашифровывать и расшифровывать данные:

 ```
resource "yandex_resourcemanager_folder_iam_member" "sa-editor-encrypter-decrypter" {
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.service.id}"
}
 ```
Создал симметричный ключ шифрования с алгоритмом шифрования AES_128 и временем жизни 24 часа:

```
resource "yandex_kms_symmetric_key" "secret-key" {
  name              = "key-1"
  description       = "ключ для шифрования бакета"
  default_algorithm = "AES_128"
  rotation_period   = "24h"
}
```

Применяю ключ шифрования к созданному ранее бакету:

```
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.secret-key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
```

Результат применения:

![as](./images/yc%20kms%20symmetric-key%20list.jpg)

>Ключ активен

Проверяю доступ к файлу в бакете

![as](./images/accessDenied%20file.jpg)

>Доступа к файлу в бакете нет, т.к. он зашифрован.

2. Для выполнения задания делаю следующие шаги:

- Созданю запрос на создание сертификата Let`s Encrypt для домена simnet.website.yandexcloud.net

![as](./images/create%20get%20ssl.jpg)

- Создаю бакет с таким же именем, загружаю в него картинку, index.html с сылкой на картинку и файл с сылкой размещения и содержимым из запроса

![as](./images/bucket%20for%20site.jpg)

- В настройкай бакета включаю доступность веб-сайта

![as](./images//bucket%20web%20site.jpg)

- Выстаавляю права доступа для всех пользователей с правами редактирования для тестовой 100%-й доступности.

![as](./images/prava%20dostupa.jpg)

- Завершение проверки сертификата

![as](./images/valid%20ssl.jpg)

- В настройках бакета включаю HTTPS

![as](./images/https%20bucket.jpg) 

- Проверяю доступность и защищённость сайта

![as](./images/finish%20site.jpg)

>Сайт доступен и защищён

----

Все манифесты размещены в [каталоге](https://github.com/VladimirEremenko-web/devops-netology/tree/main/clopro-homeworks/03/src)