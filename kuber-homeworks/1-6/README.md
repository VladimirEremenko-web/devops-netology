# Домашнее задание к занятию «Хранение в K8s. Часть 1»

### Задание 1. Создать Deployment приложения, состоящего из двух контейнеров и обменивающихся данными.

1. Создал Deployment приложения, состоящего из контейнеров busybox и multitool. Сделал так, чтобы busybox писал каждые пять секунд в файл `testlog` в общей директории.

![Скрин](./images/create%20dpl.jpg)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dpl-volume
  namespace: netology-6
spec:
  selector:
    matchLabels:
      app: volume
  replicas: 1
  template:
    metadata:
      labels:
        app: volume
    spec:
      containers:
        - name: busybox
          image: busybox:1.36.1
          command:
            [
              "sh",
              "-c",
              watch -n5 "echo 'Hello Netology!' >> /output/testlog.txt",
            ]
          volumeMounts:
            - name: volume
              mountPath: /output
        - name: multitool
          image: wbitt/network-multitool
          command: ["sh", "-c", "tail -f /output/testlog.txt"]
          volumeMounts:
            - name: volume
              mountPath: /output
      volumes:
        - name: volume
          emptyDir: {}
```

2. Проверяю генерацию записи в файл каждые 5 секунд и возможность чтения файла из контейнеров busybox и multitool.

`busybox`
![Скрин](./images/logs%20busybox%20task1.jpg)

`multitool`
![Скрин](./images/logs%20multitool%20task1.jpg)

### Задание 2. Создать DaemonSet приложения, которое может прочитать логи ноды.

1. Создал DaemonSet приложения, состоящего из multitool и обеспечил возможность чтения файла /var/log/syslog кластера MicroK8S через subPath, чтобы не вытаскивать всё из var/log

![Скрин](./images/create%20dpl.jpg)

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: ds
  namespace: netology-6
spec:
  selector:
    matchLabels:
      name: ds
  template:
    metadata:
      labels:
        name: ds
    spec:
      containers:
        - name: multitool
          image: wbitt/network-multitool
          volumeMounts:
            - name: newdir
              mountPath: /microk8slogs/syslog
              subPath: syslog
            - name: varlog
              mountPath: /var/log/syslog
              readOnly: true
      volumes:
        - name: newdir
          hostPath:
            path: /var/log
        - name: varlog
          hostPath:
            path: /var/log
```

2. Проверяю чтение файла из нутри пода.

![Скрин](./images/check%20logs%20ds%20task2.jpg)

-----
Манифесты размещены в [каталоге](https://github.com/VladimirEremenko-web/devops-netology/tree/main/kuber-homeworks/1-6/configs)