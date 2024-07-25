# Домашнее задание к занятию «Helm»

### Задание 1. Подготовить Helm-чарт для приложения

1. УСтановил Helm на рабочий ПК

![as](./images/helm%20version.jpg)

2. Создал свой `Chart` с названием `test-chart`

![as](./images/create%20chart%20task1.jpg)

3. Создал файлы `values` для разных окружений `dev`, `test`, `prd`, где определил версии образов с разными версиями. Приложения будут развернуты разными Deployment.

### Задание 2. Запустить две версии в разных неймспейсах

1. Создал отдельный Namespace с именем app1, запускаю версии `dev` и `test` приложения в этом Namespace:

![as](./images/create%20ns%20and%20install%20charts%20task2.jpg)

2. Проверяю `list` и `deployments`

![as](./images/check%20resault%20task2.jpg)

3. Создаю отдельный Namespace с именем app2, запускаю версию `prd` приложения в этом Namespace

![as](./images/create%20chart%20ns%20app2%20adn%20check%20task2.jpg)

4. Приложения развернуты и доступны
5. Проверю доступность приложения в браузере используя `port-forward`

![as](./images/port%20forward.jpg)

![as](./images/check%20soft%20in%20browser.jpg)

Приложение доступно в браузере. Установка приложения с помощью Helm успешно завершена.