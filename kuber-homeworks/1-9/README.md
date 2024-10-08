# Домашнее задание к занятию «Управление доступом»

### Задание 1. Создайте конфигурацию для подключения пользователя

1. Создаю и подписываю SSL-сертификат для подключения к кластеру.

 - Через `openssl` создал файл ключа:

![as](./images/create%20key%20file%20lanc1k.jpg)

 - C ВМ где развернут Kuber достаю файлы `ca.crt` и `ca.key`
 
 - Создал запрос на подписание сертификата (CSR):

 ![asd](./images/request%20write%20cert.jpg)

  - Сгенерировал файл сертификата(CRT):

  ![sa](./images/generate%20file%20cert.jpg)

  2. Настраиваю конфигурационный файл kubectl для подключения.

- Создал пользователя `mytest` и настроил его на использование созданного выше ключа:

![as](./images/set%20creditional%20lanc1k.jpg)

- Создал новый контекст с именем mytest-context и подключил его к пользователю `mytest`, созданный ранее:

![as](./images/create%20lanc1k%20context.jpg)

![sad](./images/get%20context.jpg)

3. Для применения и тестирования манифестов ролей:

- Создал новый namespace

![as](./images/create%20and%20get%20namespace.jpg)

- На ВМ с кубером включил RBAC

![as](./images/rbac%20enable.jpg)

- Применил манифесты создания роли (Role) и привязки роли к Namespace (RoleBinding):

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-viewer
  namespace: netology-9
rules:
  - apiGroups: [""]
    resources: ["pods", "pods/log"]
    verbs: ["get", "watch", "list"]
  - apiGroups: ["extensions", "apps"]
    resources: ["deployments"]
    verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
```

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: netology-9
subjects:
  - kind: User
    name: mytest
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-viewer
  apiGroup: rbac.authorization.k8s.io
```

![as](./images/apply%20and%20get%20role%20rolebindings.jpg)

4. Тестирование прав пользователя

- Меняю контекст на `mytest-context`

![as](./images/switch%20context%20lanc1k.jpg)

- Проверяю восможность разворачивания `deployment` в разрешенном namespace

![as](./images/create%20dpl%20with%20lanc1k%20context.jpg)

- Попробовал проверить поды в дефолтном namespace

![as](./images/get%20pods%20default%20ns%20test%20context.jpg)

Получил ошибку, т.к. нет прав

- Попробовал запросить поды в разрешенном namespace `netology-9`

![as](./images/get%20pods%20ns%20netology9%20test%20context.jpg)

Поды читаются.

- Проверяю возможность чтения логов пода в namespace `netology-9`

![as](./images/get%20logs%20with%20test%20context.jpg)

Логи читаются

- Проверяю возможность использования `describe` пода в namespace `netology-9`

![as](./images/describe%20pod%20with%20test%20context.jpg)

Описание выводится, права работают.

P.s. Сертификаты не прикладываю, кластер постоянный.

-----

Манифесты размещены в [каталоге](https://github.com/VladimirEremenko-web/devops-netology/tree/main/kuber-homeworks/1-9/configs)