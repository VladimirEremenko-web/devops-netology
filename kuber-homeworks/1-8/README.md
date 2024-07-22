# Домашнее задание к занятию «Конфигурация приложений»

### Задание 1. Создать Deployment приложения и решить возникшую проблему с помощью ConfigMap. Добавить веб-страницу

1. Создал Deployment приложения, состоящего из контейнеров nginx и multitool

![Скрин](./images/create%20dpl%20task1.jpg)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-multitool
  namespace: netology-8
spec:
  selector:
    matchLabels:
      app: ngmult
  replicas: 1
  template:
    metadata:
      labels:
        app: ngmult
    spec:
      containers:
        - name: nginx
          image: nginx:1.27.0
          ports:
            - containerPort: 80
          volumeMounts:
            - name: nginx-index-file
              mountPath: /usr/share/nginx/html/
        - name: multitool
          image: wbitt/network-multitool
          ports:
            - containerPort: 8080
          env:
            - name: HTTP_PORT
              valueFrom:
                configMapKeyRef:
                  name: multitool-maps
                  key: HTTP_PORT
      volumes:
        - name: nginx-index-file
          configMap:
            name: multitool-maps
```

2. Т.к. `multitool` имеет так же 80-й порт(а nginx его уже использует), в `ConfigMap` передал порт `1180`. Так же через него передал кастомную html страничку.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: multitool-maps
  namespace: netology-8
data:
  HTTP_PORT: "1180"
  index.html: |
    <html>
    <h1>Hey Hetology!</h1>
    </br>
    <h1>Test custom page</h1>
    </html>
```

![cd](./images/test%20pod%20with%20configmap%20task1.jpg)

Pod запустился.

3. Создал и поднял сервис. Проверяем доступность страницы(переданную в ConfigMap) из под контейнера `multitool`

![cd](./images/page%20with%20svc%20multitool%20task1.jpg)

### Задание 2. Создать приложение с вашей веб-страницей, доступной по HTTPS

1. Создал Deployment приложения, состоящего из Nginx и подключил кастомную страничку через ConfigMap(по аналогии с заданием 1).

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-only
  namespace: netology-8
  labels:
    app: nginx-frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-frontend
  template:
    metadata:
      labels:
        app: nginx-frontend
    spec:
      containers:
        - name: nginx
          image: nginx:1.27.0
          ports:
            - containerPort: 80
          readinessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 5
            periodSeconds: 10
          livenessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 15
            periodSeconds: 20
          volumeMounts:
            - name: nginx-mount
              mountPath: /usr/share/nginx/html
      volumes:
        - name: nginx-mount
          configMap:
            name: nginx-maps
```

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-maps
  namespace: netology-8
data:
  index.html: |
    <html>
    <h1>Hey Hetology!</h1>
    </br>
    <h1>Test custom page with Nginx</h1>
    </html>
```

![sd](./images/status%20pod%20task2.jpg)

2. Сгенерировал самоподписанный сертификат

![.](./images/generate%20openssl.jpg)

3. Создал `Secret`, `Ingress` и `Service`

>Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  namespace: netology-8
spec:
  type: ClusterIP
  selector:
    app: nginx-frontend
  ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: 80
```

> Secret

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: ingress-cert
  namespace: netology-8
type: kubernetes.io/tls
data:
  tls.crt: MIID7zCCAtegAwIBAgIUIOfBvhudtwj8IZ2GvERlDEDvPF0wDQYJKoZIhvcNAQELBQAwgYUxCzAJBgNVBAYTAlJVMQ8wDQYDVQQIDAZNb3Njb3cxDzANBgNVBAcMBk1vc2NvdzEPMA0GA1UECgwGbGFuYzFrMQ8wDQYDVQQLDAZsYW5jMWsxEjAQBgNVBAMMCWxhbmMxay5ydTEeMBwGCSqGSIb3DQEJARYPdmx2MjAwNkBtYWlsLnJ1MCAXDTI0MDcyMjEzMDA1OVoYDzIwNTExMjA3MTMwMDU5WjCBhTELMAkGA1UEBhMCUlUxDzANBgNVBAgMBk1vc2NvdzEPMA0GA1UEBwwGTW9zY293MQ8wDQYDVQQKDAZsYW5jMWsxDzANBgNVBAsMBmxhbmMxazESMBAGA1UEAwwJbGFuYzFrLnJ1MR4wHAYJKoZIhvcNAQkBFg92bHYyMDA2QG1haWwucnUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDJ8BkJO+PTgCN/rFCBoJOrOYFUfmissuWBrxEJuLBKBTOAvrPEblMtJYgrSLJjz3urGv/9sTJ5gXPkiEYs/JaTAJ66V34JI5MVwJr0OqwBeDLK8f+sTzTMXpDOzDcqGrtRNKcGDhSeE2IokcvnNQHZNpsrQ6jrBmTZKXTLF9S4v+g6rwonmmispT5i2CnLkOsrt46Y1X8B2IzghjX2EcSKEFpThHiExz3zGEkr+No1qJjjceL8QP0uvfaTbFni3BTxawKd24JK+6FGhHR4lOHXwqc5JO90pljm65j+YYniKldlSNZReG68HjEY7P1VPvUnBSNKtdb2UXFKamfx9nKFAgMBAAGjUzBRMB0GA1UdDgQWBBQUcGLEI6FS2wwt+EVUwjb02CTDgTAfBgNVHSMEGDAWgBQUcGLEI6FS2wwt+EVUwjb02CTDgTAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQAVmTqgPplVK208llx1G/LHG39BPnjL4rXfjoTBhGnbQNIjwPT5Cm0hA0lf3EXWJh3u3gWrT8jCI3RvJeupE2UmzoE4eSSkS43AzErgekLWleE0O0Chxo/1ttvpfIqHuSOHS/zrfLtXneEdfO0cEZPkxpxA2qHzXOFoHAcnoHPOw2p0zM3TeF/VdS3cNZf1li94Flc/J0aqW8WzHEaViAYSlMvKpytonpqMFBUtBfMCnyZW92JgHPjOQfto4NyFq27dW0qprnrjvefsBurD29/H0+l8fh5m5r8MvHUI0wksvLJ18gBI88MUGTADUQPHx/XigYoCn02cQXxpk6XNATP3
  tls.key: MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDJ8BkJO+PTgCN/rFCBoJOrOYFUfmissuWBrxEJuLBKBTOAvrPEblMtJYgrSLJjz3urGv/9sTJ5gXPkiEYs/JaTAJ66V34JI5MVwJr0OqwBeDLK8f+sTzTMXpDOzDcqGrtRNKcGDhSeE2IokcvnNQHZNpsrQ6jrBmTZKXTLF9S4v+g6rwonmmispT5i2CnLkOsrt46Y1X8B2IzghjX2EcSKEFpThHiExz3zGEkr+No1qJjjceL8QP0uvfaTbFni3BTxawKd24JK+6FGhHR4lOHXwqc5JO90pljm65j+YYniKldlSNZReG68HjEY7P1VPvUnBSNKtdb2UXFKamfx9nKFAgMBAAECggEABMADUr/des+NkOFXLnQTbShn4KUtkKcPoNE4USEj8nB0tu9QGrYupNtNvJjpQKb0MCuX1cTvMe5ShnpnI4Pt2yIyrvbuZcgisP+2wA5zloBC5O+0KtPdIykz9k1VnIWu83jN11Be+fNCReqHYED+B2OSWv5B269q5rR5L8AigUBQUX5oAP/UEW40ZZtWU9CN3kEMsKIc0RiQX2UBVntfomYpyCM2WNIkDd9tbGgn5VihAL+BBKiyuM3fENgt/D4Y6bjuxzDDhrzj40DPx4+UAymTvRn4cQCRikr1944N/U0wgTNEn1+ZXl7aeAAg+sZ/L6XUl/oOYeLxSmpX1hr++QKBgQD0sOQMdyPSI/1M0jLEMdLpXuHYcmhI6kU94Ff6SXWcy1ZCophDAMVKpBhKktRRndnQiEOqir1IX5613ET+mP6YpMmQYdmqDIi6wvlkB/dihscsnVSU1xwm/AGJhZttLbU5rsPsAtYVvi1icMor33GQWWgkce4XkHeNnxMW3CaAyQKBgQDTRV2HNIZofcn5Q04LeOi5W/sgYuDwFu5Uh3kaT8JtZA/8fWcSEcy/exe/aTv0Gsks5mxaYFGWwFO1cxipHaaorpP+ux8a4F/IR8hkMsfGoM1inE4VkLzLr/Y1hnhxT2uAtHCL7qP+6GYL+N4yKpDbOT89kU6H+9zgcNnQds6d3QKBgQCww9j66FaISFeEV5U1BolG7bRZmMydYCAFQzxLIyZDzuDR4oP8Y2IjOcgSl1+qVk4zxzyaxv9WeT0+Q5HUGtJRkznJg+aqYcOkp5ViHh8onhTktgOUQpGj2AmEP3C4vnxc31PJ+4KM0oYWx0RFzXVMwknpiiRmAYdcV76ClSd7gQKBgG43y9lTb6NnrEzb7gVSKKc680IsE4ltjRyQKH+viJElGKnyiikFHDnw76yuK9bnenhwJarogOgSohkRWJYxn9Z0bUUBPfL5hz6nJEYRr+NR1JRTUvExNy1UOTAnXQJQGpdkiyqVbvz3JPWt+c1WI4gaz4FBIyUSImL8vMVildwJAoGBALvDdXhJ5p/pCuieMOmEoDvgxxH/bfy0TOgfK34rRUPVUP42mR1EoDDbfFnnUFPYkQ9VZxkJm5DJpz286l1cQ3eCoHYQnRW9F4O3Nvd208e4ied+m45J8v0J5anbGcOxwrPHXJ/KBOtXRYpzuhTTonYdgW3Y3y5Ao0Iz/V04eVY1
```

![dsf](./images/secret%20statsu%20task2.jpg)

> Ingress

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  namespace: netology-8
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    kubernetes.io/ingress.class: nginx
spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - lanc1ktest.ru
      secretName: ingress-cert
  rules:
    - host: lanc1ktest.ru
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: nginx-service
                port:
                  number: 80
```

4. Проверяем доступность хоста

![csd](./images/curl%20to%20dns%20task2.jpg)

