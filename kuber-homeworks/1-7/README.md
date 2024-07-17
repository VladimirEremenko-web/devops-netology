# Домашнее задание к занятию «Хранение в K8s. Часть 2»

### Задание 1. Создать Deployment приложения, использующего локальный PV, созданный вручную.

1. Создал Deployment приложения, состоящего из контейнеров busybox и multitool.

![Скрин](./images/create%20dpl%20task1.jpg)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dpl-volume
  namespace: netology-7
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
          persistentVolumeClaim:
            claimName: pvc-vol
```

>Под в статусе `Pending` по причине того, что нет pvc

2. Создал PV и PVC для подключения папки на локальной ноде, которая будет использована в поде.

![Screen](./images/add%20pv%20pvc%20and%20get%20task1.jpg)

>Проверяем статус пода, который ожидал создания PVC

![Скрин](./images/get%20pod%20task1.jpg)

3. Проверяю, что multitool может читать файл, в который busybox пишет каждые пять секунд в общей директории.

![Скриn](./images/write%20logs%20multitool%20task1.jpg)
Логи контейнера
![Скрин](./images/logs%20container%20task1.jpg)

>Multitool имеет доступ на чтение файла

4. Удаляю Deployment и PVC

![Скрин](./images/delete%20dpl%20and%20pvc.jpg)

>Проверяю статус PV

![screen](./images/status%20pv%20after%20delete%20pvc%20and%20dpl.jpg)

>PV перешел в состояние Failed, т.к. контроллер PV не сумел удалить данные по пути /data/pvc-first. По умолчанию он может удалить только данные по пути /tmp.

5. Проверяю, что файл сохранился на локальном диске ноды

![Скрин](./images/file%20on%20node%20task1.jpg)

> Файл присутствует в директории `/data/pvc`

Удаляю файл PV 

![sc](./images/after%20delete%20pv%20node%20task1.jpg)

> После удаления PV, файл в директории `/data/pvc` остается на месте из-за особенностей работы контроллера PV с `hostPath`. В случае если в манифесте PV политика `persistentVolumeReclaimPolicy` будет установлена в `Recycle`, то файл будет удален.

### Задание 2. Создать Deployment приложения, которое может хранить файлы на NFS с динамическим созданием PV.

1. Включил и настроил NFS-сервер на MicroK8S
2. Создал Deployment приложения состоящего из multitool, и подключенный к нему PV, созданный автоматически на сервере NFS.

![sc](./images/add%20dpl%20nfs%20task2.jpg)

3. Проверяю возможность чтения и записи файла изнутри пода

![sc](./images/check%20write%20text%20with%20pod%20task2.jpg)

Записанный файл на самой ноде через NFS

![sc](./images/nfs%20storage%20on%20node%20task2.jpg)

-----
Манифесты размещены в [каталоге](https://github.com/VladimirEremenko-web/devops-netology/tree/main/kuber-homeworks/1-7/configs)