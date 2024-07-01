# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 1»

### Задание 1. Создать Deployment и обеспечить доступ к контейнерам приложения по разным портам из другого Pod внутри кластера

1. Создал Deployment приложения, состоящего из двух контейнеров (nginx и multitool), с количеством реплик 3 шт.

![Скриншот](./images/task1_rep3.jpg)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: network-dep-1
  namespace: netology-4
spec:
  selector:
    matchLabels:
      app: netdep
  replicas: 3
  template:
    metadata:
      labels:
        app: netdep
    spec:
      containers:
        - name: nginx
          image: nginx:1.27.0
          ports:
            - containerPort: 80
        - name: multitool
          image: wbitt/network-multitool
          ports:
            - containerPort: 8080
          env:
            - name: HTTP_PORT
              value: "1180"
```

2. Создал Service, который обеспечивает доступ внутри кластера до контейнеров приложения из п.1 по порту 9001 — nginx 80, по 9002 — multitool 8080.

![Скриншот](./images/svc_with_ports.jpg)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: network-service-1
  namespace: netology-4
spec:
  selector:
    app: netdep
  ports:
    - protocol: TCP
      name: nginx
      port: 9001
      targetPort: 80
    - protocol: TCP
      name: multitool
      port: 9002
      targetPort: 1180
```

3. Создал отдельный Pod с приложением multitool и убедился с помощью `curl`, что из пода есть доступ до приложения из п.1 по разным портам в разные контейнеры.

![Скриншот](./images/multi_pod.jpg)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: multitool
  namespace: netology-4
spec:
  containers:
    - name: multitool
      image: wbitt/network-multitool
      ports:
        - containerPort: 8080
```

`curl` до подов из п.1

Nginx
![Скриншот](./images/nginx_with_multitool_80.jpg)
Multitool
![Скриншот](./images/multitool_with_multitool_1180.jpg)

4. Lоступ с помощью `curl` по доменному имени сервиса через порты

Nginx
![Скриншот](./images/nginx_with_svc_9001.jpg)
Multitool
![Скриншот](./images/multitool_with_svc_9002.jpg)

### Задание 2. Создать Service и обеспечить доступ к приложениям снаружи кластера

1. Создал отдельный Service приложения из Задания 1 с возможностью доступа снаружи кластера к nginx, используя тип NodePort.

![Скриншот](./images/create%20svc%20nodeport.jpg)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: svc-nodeport
  namespace: netology-4
spec:
  type: NodePort
  selector:
    app: netdep
  ports:
    - port: 80
      name: nginx-port
      targetPort: 80
      nodePort: 30001
    - port: 8080
      name: multitool-port
      targetPort: 1180
      nodePort: 30002
```

2. Доступ через браузер с локального ПК через связку IP:Port

Nginx
![Скриншот](./images/nginx_nodeport.jpg)
Multitool
![Скриншот](./images/multitool_nodeport.jpg)