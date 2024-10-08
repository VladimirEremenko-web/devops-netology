# Дипломный практикум в Yandex.Cloud

## Цели:
1. Подготовить облачную инфраструктуру на базе облачного провайдера Яндекс.Облако.
2. Запустить и сконфигурировать Kubernetes кластер.
3. Установить и настроить систему мониторинга.
4. Настроить и автоматизировать сборку тестового приложения с использованием Docker-контейнеров.
5. Настроить CI для автоматической сборки и тестирования.
6. Настроить CD для автоматического развёртывания приложения.

## Выполнение дипломного практикума:

#### Создание облачной инфраструктуры

>Для начала подготовлю облачную инфраструктуру в ЯО при помощи Terraform.

1. Создаю сервисный аккаунт с правами `editor` для работы с облачной инфраструктурой и статический ключ доступа для сервисного аккаунта:

```yaml
resource "yandex_iam_service_account" "service" {
  folder_id = var.folder_id
  name      = var.account_name
}

resource "yandex_resourcemanager_folder_iam_member" "service_editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.service.id}"
}

resource "yandex_iam_service_account_static_access_key" "terraform_service_account_key" {
  service_account_id = yandex_iam_service_account.service.id
}
```

2. В качестве `backend` для Terraform использую S3-bucket. Переменные `AWS_ACCESS_KEY` и `AWS_SECRET_KEY` запишу в файл `terraform/backend.tfvars` ввиду того, что их не рекомендуется хранить в облаке и они будут использованы в качестве переменных окружения и секретов в GitHub для срабатывания Github Actions. Передаю их в файл с помощью `local-exec`:

```yaml
resource "yandex_storage_bucket" "lanc1k-bucket" {
  bucket     = "lanc1k-state"
  access_key = yandex_iam_service_account_static_access_key.terraform_service_account_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.terraform_service_account_key.secret_key

  anonymous_access_flags {
    read = false
    list = false
  }

  force_destroy = true

  provisioner "local-exec" {
    command = "echo export ACCESS_KEY=${yandex_iam_service_account_static_access_key.terraform_service_account_key.access_key} > ../terraform/backend.tfvars"
  }

  provisioner "local-exec" {
    command = "echo export SECRET_KEY=${yandex_iam_service_account_static_access_key.terraform_service_account_key.secret_key} >> ../terraform/backend.tfvars"
  }
}
```
![cr](./images/service%20acc%20and%20bucket.jpg)

S3-bucket и сервисный аккаунт `service` созданы и доступны.

Выполняю настройку для использования bucket в качестве backend для Terraform:

```yaml
terraform {
  backend "s3" {
    endpoint                    = "storage.yandexcloud.net"
    bucket                      = "lanc1k-state"
    region                      = "ru-central1"
    key                         = "lanc1k-state/terraform.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
```

Код настраивает Terraform на использование Yandex Cloud Storage в качестве места для хранения файла состояния terraform.tfstate, который содержит информацию о конфигурации и состоянии управляемых Terraform ресурсов. Чтобы код был корректно применен и Terraform успешно инициализировался, задал параметры `AWS_ACCESS_KEY` и `AWS_SECRET_KEY` из файла `terraform/backend.tfvars` в качестве переменных окружения для доступа к S3 хранилищу.

3. Создал VPC с подсетями в разных зонах доступности:

```yaml
resource "yandex_vpc_network" "diplom" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "diplom-subnet1" {
  name           = var.subnet1
  zone           = var.zone1
  network_id     = yandex_vpc_network.diplom.id
  v4_cidr_blocks = var.cidr1
}

resource "yandex_vpc_subnet" "diplom-subnet2" {
  name           = var.subnet2
  zone           = var.zone2
  network_id     = yandex_vpc_network.diplom.id
  v4_cidr_blocks = var.cidr2
}
```

Используемые переменные занесены в файл [variables.tf](https://github.com/VladimirEremenko-web/devops-netology/blob/main/diplom/terraform/variables.tf)

4. Для подготовки инфраструктуры Kubernetes кластера создаю `master` и две `worker` ноды

Код создания `master` ноды размещен в файле [master.tf](https://github.com/VladimirEremenko-web/devops-netology/blob/main/diplom/terraform/master.tf)

Код создания `worker` нод размещен в файле [worker.tf](https://github.com/VladimirEremenko-web/devops-netology/blob/main/diplom/terraform/worker.tf)

Так же создаю ресурс из файла [ansible.tf](https://github.com/VladimirEremenko-web/devops-netology/blob/main/diplom/terraform/ansible.tf), который на основе шаблона [hosts.tftpl](https://github.com/VladimirEremenko-web/devops-netology/blob/main/diplom/terraform/hosts.tftpl) создает inventory файл для будующего разворачивания Kubernetes кластера(использование IP worker и master нод) на основе Kubespray.

Код для установки необходимых пакетов на виртуальные машины при их развертывании находится в файле [cloud-init.yml](https://github.com/VladimirEremenko-web/devops-netology/blob/main/diplom/terraform/cloud-init.yml). Благодаря ему на ВМ установятся пакеты mc, git, curl и т.д.

Проверю все ресурсы в интерфейсе УС

- Сервисный аккаунт

![as](./images/service%20acc%20console.jpg)

- S3

![as](./images/S3%20console.jpg)

- BM

![as](./images/BM%20console.jpg)

- VPC и subnets

![as](./images/VPC%20and%20subnets%20console.jpg)

Ресурсы успеншно создались.

5. Для автоматического разворачивания инфраструктуры из Github использую Github Actions, используя подход `workflow_dispatch`, описанный в файле [main.yam](https://github.com/VladimirEremenko-web/devops-netology/blob/main/.github/workflows/main.yml). Предварительно в настройках репозитория необходимо занести `secrets`, в которых мы указываем используемые секреты.

![as](./images/workfolws%20github.jpg)

При внесении `true` в необходимом поле инфраструктура либо разворачивается, либо дестроится. Так же при пуше изменений в ветку main в папке diplom/terraform инфраструктура меняется. Успешное выполнение заданий на скриншоте.

Код Terraform для создания сервисного аккаунта, статического ключа и S3-bucket доступен по ссылке: https://github.com/VladimirEremenko-web/devops-netology/tree/main/diplom/s3

Код создания сети и ВМ с компонентами: https://github.com/VladimirEremenko-web/devops-netology/tree/main/diplom/terraform

#### Создание Kubernetes кластера

Для разворачивания Kubernetes кластера использую репозиторий Github [Kubespray](https://github.com/kubernetes-sigs/kubespray). Склонировал его себе на локальный ПК.

При разворачивании инфраструктуры использовался ресурс, который на основе шаблона [hosts.tftpl](https://github.com/VladimirEremenko-web/devops-netology/blob/main/diplom/terraform/hosts.tftpl) создал файл hosts.yaml по пути /home/lanc1k/lessons/kubespray/inventory/mycluster

Ресурс создания файла:

```yaml
resource "local_file" "hosts_cfg_kubespray" {
  count = var.exclude_ansible ? 0 : 1 # Если exclude_ansible true, ресурс не создается

  content = templatefile("${path.module}/hosts.tftpl", {
    workers = yandex_compute_instance.worker
    masters = yandex_compute_instance.master
  })
  filename = "/home/lanc1k/lessons/kubespray/inventory/mycluster/hosts.yaml"
}
```
Из директории `/home/lanc1k/lessons/kubespray/` запускаю установку:

`ansible-playbook -i inventory/mycluster/hosts.yaml -u ubuntu --become --become-user=root --private-key=~/.ssh/id_ed25519 -e 'ansible_ssh_common_args="-o StrictHostKeyChecking=no"' cluster.yml --flush-cache`

![ыф](./images/install%20kube.jpg)

Через некоторое время кластер со всеми компонентами установлен.

Подключившись к `master` ноде создал каталог `~/.kube` и перенёс туда конфиг кластера наделив правами 

![as](./images/config%20file%20kube%20home%20dir.jpg)

Проверяю доступность Pod`ов и нод кластера из `master` ноды

![as](./images/check%20pods%20and%20nodes.jpg)

Kubernetes кластер готов к работе.

#### Создание тестового приложения

1. Создам отдельную папку в репозитории под тестовое приложение: https://github.com/VladimirEremenko-web/devops-netology/tree/main/diplom/mysite

2. Создаю статическую страницу в каталоге `src/`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diplom page</title>
</head>
<body>
    <H1>Hello Netology</H1>
    <H2>This my diplom page</H2>
</body>
</html>
```

3. Пишу Dockerfile для сборки приложения

```Dockerfile
FROM nginx:latest
RUN rm -rf /usr/share/nginx/html/*
COPY src/ /usr/share/nginx/html/
EXPOSE 80
```

4. Собираю и публикую приложение в DockerHub, придварительно авторизовавшись 

![as](./images/dockerhub%20image.jpg)

Docker образ опубликован в хранилище и готов к использованию.

#### Подготовка системы мониторинга и деплой приложения

1. Добавляю репозиторий prometheus-community для его установки с помощью helm:

`helm repo add prometheus-community https://prometheus-community.github.io/helm-charts`

![as](./images/helm%20add%20prometh.jpg)

2. Для доступа к Grafana снаружи кластера Kubernetes буду использовать тип сервиса `NodePort`.

Сохраню значения по умолчанию Helm чарта `prometheus-community` в файл и отредактирую его:

`helm show values prometheus-community/kube-prometheus-stack > helm-prometheus/values.yaml`

![asd](./images/add%20prom%20helm%20values.jpg)

3. Изменил дефолтный пароль для доступа к web-интерфейсу и присвоил `nodePort: 30050`

![as](./images/grafana%20nodeport.jpg)

4. Используя Helm и подготовленный файл значений `values.yaml` выполню установку `prometheus-community` в отдельный namespace `monitoring`:

`helm upgrade --install monitoring prometheus-community/kube-prometheus-stack --create-namespace -n monitoring -f helm-prometheus/values.yaml`

![as](./images/install%20monitoring.jpg)

Результат установки

![as](./images/get%20pods%20monitoring.jpg)

web-интерфейс:

![as](./images/auth%20grafana.jpg)

Мониторинг установлен, Kubernetes кластер отображается на дашборде

![as](./images/monitoring%20cluster.jpg)

---

>Разворачиваю созданное ранее приложение

1. Создам отдельный namespace

![as](./images/create%20app%20ns.jpg)

2. Пишу манифест [dpl.yaml](https://github.com/VladimirEremenko-web/devops-netology/blob/main/diplom/k8s-app-mysite/dpl.yaml) и [svc.yaml](https://github.com/VladimirEremenko-web/devops-netology/blob/main/diplom/k8s-app-mysite/svc.yaml) и применяю.

![as](./images/dpl%20app%20and%20svc.jpg)

Проверяю доступность приложения

![as](./images/web%20app%20dest.jpg)

3. С помощью Terraform создаю балансировщик нагрузки. 
- Создаю группу балансировщика нагрузки, которая будет использоваться для балансировки нагрузки между экземплярами. 
- Создаю балансировщик с именем grafana, определяется слушатель на порту 3000, который перенаправляет трафик на порт 30050 целевого узла, настраивается проверка работоспособности (healthcheck) на порту 30050. 
- Создается балансировщик с именем web-app, определяется слушатель на порту 80, который перенаправляет трафик на порт 30051 целевого узла, настраивается проверка работоспособности (healthcheck) на порту 30051.

Код описан в файле [load-balancer.tf](https://github.com/VladimirEremenko-web/devops-netology/blob/main/diplom/terraform/load-balancer.tf)

Результат в web УС

![as](./images/lb%20console.jpg)

Првоерю web-доступы приложений

 - APP:

![as](./images/web%20app%20lb.jpg)

 - Grafana

![as](./images/grafana%20lb.jpg)

Развёртывание системы мониторинга и тестового приложения завершено.

#### Установка и настройка CI/CD

1. Создаю проект `mydiplom` на https://gitlab.com/ и пушу туда код своего приложения

![as](./images/project%20diplom%20gitlab.jpg)

2. Устанавливаю на master ноде Gitlab Runner и регистрирую его с тегом `diplom`, выбирая экспортер Docker

![as](./images/gitlab%20runner.jpg)

3. Для того, чтобы CI/CD отработало на основе файла `.gitlab-ci.yml`, добавляю переменные с параметрами доступа к DockerHub и удалённому хосту для деплоя.

![as](./images/CI%20varibles.jpg)

4. DID не стал использовать, потому как в реальных проектах это мало где используется. Связанно это с безопасностью, т.к. при таком методе необходимо включать privileged = true. Подход с kaniko решает данную проблему и на мой взгляд работает стабильнее. К томуже при использовании DID есть риск ловить ошибки доступа к docker.socket.

5. Файл `.gitlab-ci` получился следующего вида:

<details><summary>gitlab-ci.yaml</summary>

```yaml
stages:
  - build
  - deploy

variables:
  IMAGE_TAG_LATEST: latest
  IMAGE_TAG_COMMIT: ${CI_COMMIT_SHORT_SHA}
  VERSION: ${CI_COMMIT_TAG}
  NAMESPACE: "diplom-static-site"
  DEPLOYMENT_NAME: "diplom"


build:
  stage: build
  image:
    name: gcr.io/kaniko-project/executor:v1.22.0-debug
    entrypoint: [""]
  tags:
    - diplom
  only:
    - main
    - tags
  script:
    - mkdir -p /kaniko/.docker
    - echo "{\"auths\":{\"${DOCKER_REGISTRY}\":{\"username\":\"${DOCKER_USER}\",\"password\":\"${DOCKER_PASSWORD}\"}}}" > /kaniko/.docker/config.json
    - cat /kaniko/.docker/config.json
    - if [ -z "$VERSION" ]; then VERSION=$IMAGE_TAG_COMMIT; fi
    - /kaniko/executor --context ${CI_PROJECT_DIR} --dockerfile ${CI_PROJECT_DIR}/Dockerfile --destination ${DOCKER_USER}/${IMAGE_NAME}:$VERSION
    - /kaniko/executor --context ${CI_PROJECT_DIR} --dockerfile ${CI_PROJECT_DIR}/Dockerfile --destination ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG_LATEST}

deploy:
  stage: deploy
  image: ubuntu
  tags:
    - diplom
  only:
    - main
    - tags
  script:
  - | # устанавливаем ssh клиент
     apt-get update
     apt-get install openssh-client -y
     apt-get install curl -y
     curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
     chmod +x /usr/local/bin/docker-compose 

  - | # подготавливаем SSH ключи
      mkdir ~/.ssh
      echo "$SSH_KEY_PRIVATE" > ~/.ssh/id_rsa
      echo "$SSH_KEY_PUB" > ~/.ssh/id_rsa.pub
      chmod 400 ~/.ssh/id_rsa
  
  - | 
      ssh -o StrictHostKeyChecking=no "$SSH_USER@$SSH_HOST"  "kubectl apply -f k8s-app/ |
      if [ -z "$VERSION" ]; then VERSION=$IMAGE_TAG_COMMIT; fi |
      kubectl set image deployment/${DEPLOYMENT_NAME} ${IMAGE_NAME}=${DOCKER_USER}/${IMAGE_NAME}:$VERSION --namespace=${NAMESPACE} |
      kubectl rollout restart deployment/${DEPLOYMENT_NAME} --namespace=${NAMESPACE} |
      kubectl rollout status deployment/${DEPLOYMENT_NAME} --namespace=${NAMESPACE}"
```
</details>

6. Стейдж `build` реализован таким образом, если `push` в репозиторий осущействляется без присвоения тега, то в реджистри DockerHub кладётся образ с тегом latest, если тег присваивается кладётся тег с версией.

Версии в DockerHub:

![as](./images/dockerhub%20versions.jpg)

7. В деплое используется подход `rollout` - "мягкой" замены работающих подов с новой версией. Считаю такой подход предпочтительным, так как он обеспечивает отказоустойчивость инеприрывность работы приложения.

Результат деплоя с новой версией:

Код новой версии в репозитории:
![as](./images/04%20test%20app.jpg)

Обновлённая страница:
![as](./images/04%20web%20app.jpg)


Результаты CI/CD пайпланов:

![as](./images/resault%20cicd.jpg)


