### 1. Сценарий выполнения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```

Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

Ссылка на репозиторий https://hub.docker.com/layers/lanc1k/lessonneto/newvers/

### 2. Посмотрите на сценарий ниже и ответьте на вопрос: «Подходит ли в этом сценарии использование Docker-контейнеров или лучше подойдёт виртуальная машина, физическая машина? Может быть, возможны разные варианты?»

Сценарий:

- высоконагруженное монолитное Java веб-приложение;

`Подходит VM ввиду высокой нагрузки, необходим прямой доступ к ресурсам.`

- Nodejs веб-приложение;

`Docker подходит для приложения Nodejs, т.к. в нём много зависимостей с подключаемыми внешними библиотеками`

- мобильное приложение c версиями для Android и iOS;

`Необходим GUI, так что подойдет виртуалка`

- шина данных на базе Apache Kafka;
`VM, т.к. используется много ресурсов`

- Elasticsearch-кластер для реализации логирования продуктивного веб-приложения — три ноды elasticsearch, два logstash и две ноды kibana;

`Так же требователен к ресурсам, поэтому VM`

- мониторинг-стек на базе Prometheus и Grafana;

`Подойдет Docker, так как данные не хранятся, и масштабировать легко`

- MongoDB как основное хранилище данных для Java-приложения;

`Высокая нагрузка, подойдёт VM`

- Gitlab-сервер для реализации CI/CD-процессов и приватный (закрытый) Docker Registry.

`VM. Необходим доступ к ресурсам`

### 3. Задача 3

- Запустите первый контейнер из образа centos c любым тегом в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера.
- Запустите второй контейнер из образа debian в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера.
- Подключитесь к первому контейнеру с помощью docker exec и создайте текстовый файл любого содержания в /data.
- Добавьте ещё один файл в папку /data на хостовой машине.
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /data контейнера.

```
vagrant@server2:~$ docker run -it --rm -d --name centos -v $(pwd)/data:/data centos:latest
Unable to find image 'centos:latest' locally
latest: Pulling from library/centos
52f9ef134af7: Pull complete
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest
644cbde6aba33ce6aa8e1d2ce579ce411fd58b7974fc6f8b6f5acb0a5c1236d4

vagrant@server2:~$ docker run -it --rm -d --name debian -v $(pwd)/data:/data debian:latest
Unable to find image 'debian:latest' locally
latest: Pulling from library/debian
94a23d3cb5be: Pull complete
Digest: sha256:2906804d2a64e8a13a434a1a127fe3f6a28bf7cf3696be4223b06276f32f1f2d
Status: Downloaded newer image for debian:latest
2b1f3290f6dc56f98f4546f4fccf73267a0baab1e382625f0955cffba40a9916
```
```
vagrant@server2:~$ docker exec -it centos bash
[root@644cbde6aba3 /]# echo "This file is written to docker CentOS" >> /data/centos.txt
[root@644cbde6aba3 /]# exit
exit
```
```
vagrant@server2:~$ sudo su
root@server1:/home/vagrant# echo "This file is written to host" >> data/host.txt
```
```
vagrant@server2:~$ docker exec -it debian bash
root@2b1f3290f6dc:/# ls data/
centos.txt  host.txt
```

### 4. Воспроизведите практическую часть лекции самостоятельно. Соберите Docker-образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.

Ссылка: https://hub.docker.com/repository/docker/lanc1k/ansible/general