# Домашнее задание к занятию 12 «GitLab»

## Подготовка к выполнению

1. Инстанс Gitlab

![Gitlab](./images/Инстанс%20Gitlab.jpg)

2. ВМ с gitlab runner

![Runner](./images/ВМ%20gitlabrunner.jpg)

3. Gitlab Runner подключенный к Gitlab

![Runner](./images/add%20runner.jpg)

4. Созданный проект с файлами

![Project](./images/проект%20с%20файлами.jpg)

## Основная часть

### DevOps

 - .gitlab-ci.yml

 ```yaml
stages:
  - build
  - deploy

image: docker:20.10.5
services:
  - docker:20.10.5-dind

builder:
  stage: build
  script:
      - docker build -t some_local_build:latest .
  only:
      - main

deployer:
    stage: deploy
    script:
        - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
        - docker build -t $CI_REGISTRY/$CI_PROJECT_PATH/hello:gitlab-$CI_COMMIT_SHORT_SHA .
        - docker push $CI_REGISTRY/$CI_PROJECT_PATH/hello:gitlab-$CI_COMMIT_SHORT_SHA
    only:
        - main

 ```

 - Dockerfile

 ```Dockerfile
FROM centos:7

RUN yum install python3 python3-pip -y
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
WORKDIR /python_api
COPY python-api.py /python_api/python-api.py
CMD ["python3", "/python_api/python-api.py"]

 ```

 - Сборка проекта

 ![image](./images/DevOps%20первая%20сборка.jpg)

 ### Product Owner

 > Созданная Issue

 ![Issue](./images/Созданная%20%20Issue.jpg)

 ### Developer

 > Закрытый Issue

 ![ClosedIssue](./images/Closed%20Issue.jpg)

 > Лог успешного выполнения пайплайна

 <details><summary>Лог выполнения builder</summary>

 ```console
Running with gitlab-runner 16.8.0 (c72a09b6)
  on myrunner sPkcD9JK, system ID: r_WSYJn3PbTQzC
Preparing the "docker" executor
00:35
Using Docker executor with image docker:20.10.5 ...
Starting service docker:20.10.5-dind ...
Pulling docker image docker:20.10.5-dind ...
Using docker image sha256:0a9822c8848df3eb0a1562e553fdd54215939ef0a528434ee026c64ff645148c for docker:20.10.5-dind with digest docker@sha256:e4ecd4e9ad5140d584669451b05e406d8cf7603e51972b862178ad93c38b2b08 ...
Waiting for services to be up and running (timeout 30 seconds)...
*** WARNING: Service runner-spkcd9jk-project-1-concurrent-0-6ee56d2212e69a2d-docker-0 probably didn't start properly.
Health check error:
service "runner-spkcd9jk-project-1-concurrent-0-6ee56d2212e69a2d-docker-0-wait-for-service" timeout
Health check container logs:
2024-02-13T19:47:41.125080282Z waiting for TCP connection to 172.17.0.3 on [2375 2376]...
2024-02-13T19:47:41.125139528Z dialing 172.17.0.3:2376...
2024-02-13T19:47:41.125238928Z dialing 172.17.0.3:2375...
2024-02-13T19:47:42.125624795Z dialing 172.17.0.3:2376...
2024-02-13T19:47:42.125653335Z dialing 172.17.0.3:2375...
Service container logs:
2024-02-13T19:47:40.685318569Z Generating RSA private key, 4096 bit long modulus (2 primes)
2024-02-13T19:47:41.215096080Z ....................................................................................................................................................++++
2024-02-13T19:47:41.387791031Z .................................................++++
2024-02-13T19:47:41.388210404Z e is 65537 (0x010001)
2024-02-13T19:47:41.401542452Z Generating RSA private key, 4096 bit long modulus (2 primes)
2024-02-13T19:47:41.429566467Z ......++++
2024-02-13T19:47:41.562161252Z .....................................++++
2024-02-13T19:47:41.562547990Z e is 65537 (0x010001)
2024-02-13T19:47:41.584663708Z Signature ok
2024-02-13T19:47:41.584683937Z subject=CN = docker:dind server
2024-02-13T19:47:41.584801964Z Getting CA Private Key
2024-02-13T19:47:41.595066398Z /certs/server/cert.pem: OK
2024-02-13T19:47:41.597615045Z Generating RSA private key, 4096 bit long modulus (2 primes)
2024-02-13T19:47:41.786161788Z .....................................................++++
2024-02-13T19:47:41.854476986Z .................++++
2024-02-13T19:47:41.854881757Z e is 65537 (0x010001)
2024-02-13T19:47:41.876188708Z Signature ok
2024-02-13T19:47:41.876202420Z subject=CN = docker:dind client
2024-02-13T19:47:41.876334155Z Getting CA Private Key
2024-02-13T19:47:41.887785971Z /certs/client/cert.pem: OK
2024-02-13T19:47:41.890677819Z mount: permission denied (are you root?)
2024-02-13T19:47:41.890735012Z Could not mount /sys/kernel/security.
2024-02-13T19:47:41.890740906Z AppArmor detection and --privileged mode might break.
2024-02-13T19:47:41.891698145Z mount: permission denied (are you root?)
*********
Pulling docker image docker:20.10.5 ...
Using docker image sha256:1588477122de4fdfe9fcb9ddeeee6ac6b93e9e05a65c68a6e22add0a98b8e0fe for docker:20.10.5 with digest docker@sha256:7ed427295687586039ff3433bb9b4419c5cf1e6294025dadf7641126665a78f5 ...
Preparing environment
00:00
Running on runner-spkcd9jk-project-1-concurrent-0 via 352e83574200...
Getting source from Git repository
00:01
Fetching changes with git depth set to 20...
Reinitialized existing Git repository in /builds/lanc1k/myproject/.git/
Checking out fdc29e66 as detached HEAD (ref is main)...
Skipping Git submodules setup
Executing "step_script" stage of the job script
00:02
Using docker image sha256:1588477122de4fdfe9fcb9ddeeee6ac6b93e9e05a65c68a6e22add0a98b8e0fe for docker:20.10.5 with digest docker@sha256:7ed427295687586039ff3433bb9b4419c5cf1e6294025dadf7641126665a78f5 ...
$ docker build -t some_local_build:latest .
#1 [internal] load build definition from Dockerfile
#1 sha256:8cdcf1c7049c6d736ae434057153c359134069e06d2d8487f680c1da6030a5f6
#1 transferring dockerfile: 278B done
#1 DONE 0.0s
#2 [internal] load metadata for docker.io/library/centos:7
#2 sha256:30875b35a89c8e8a29cd7cf120689bb68cdab8d769419707e07138dfe977d237
#2 DONE 1.1s
#3 [internal] load .dockerignore
#3 sha256:3d005307b5a012d33cac8996f2e20ebea5b69e6296e9f8df24782eb1f0f4328f
#3 transferring context: 2B done
#3 DONE 0.0s
#10 [1/6] FROM docker.io/library/centos:7@sha256:be65f488b7764ad3638f236b7b515b3678369a5124c47b8d32916d6487418ea4
#10 sha256:8aee2df8eae94a334b616b2360efaff20c8e0722b9e9251907e0264f86e84fe1
#10 DONE 0.0s
#8 [internal] load build context
#8 sha256:9b22bcb43766d5d1ee2c70ecb9e91829fc4ed6ee2b53fe6dedc5964ec1a2a280
#8 transferring context: 508B done
#8 DONE 0.0s
#7 [3/6] COPY requirements.txt requirements.txt
#7 sha256:ca611ef5fde89e89376761d4d6f819ec24d0974f034078fcb133023f7af81161
#7 CACHED
#6 [4/6] RUN pip3 install -r requirements.txt
#6 sha256:ce0e90237582b37576db8e5f7c93b70c7cf592989c2c29186e8236e171bb2197
#6 CACHED
#9 [2/6] RUN yum install python3 python3-pip -y
#9 sha256:f1144206e2c393ce7dae78da202bcabe051960e4ee53a33abc414e5f30a9c4cd
#9 CACHED
#5 [5/6] WORKDIR /python_api
#5 sha256:78e95c1dd253e1bf2535f26dc42206a588499ec96c4ffcd73b343c9b87ce157d
#5 CACHED
#4 [6/6] COPY python-api.py /python_api/python-api.py
#4 sha256:b65bcdc64b2e1cd4361fecd465706b1d64ce200d034f14c0b20dca05f8ae5842
#4 DONE 0.1s
#11 exporting to image
#11 sha256:73507cf21e1c9fa3b0e441417f84e98746a52729df769e2511c0ba0f00fd6417
#11 exporting layers 0.1s done
#11 writing image sha256:c312202380e389ea05ced3ed3eaa3ead34fd571b2dd6676ccc39788397fbd0e4 done
#11 naming to docker.io/library/some_local_build:latest done
#11 DONE 0.1s
Cleaning up project directory and file based variables
00:01
Job succeeded
```
</details>

<details><summary>Лог выполнения deployer</summary>

```console
Running with gitlab-runner 16.8.0 (c72a09b6)
  on myrunner sPkcD9JK, system ID: r_WSYJn3PbTQzC
Preparing the "docker" executor
00:35
Using Docker executor with image docker:20.10.5 ...
Starting service docker:20.10.5-dind ...
Pulling docker image docker:20.10.5-dind ...
Using docker image sha256:0a9822c8848df3eb0a1562e553fdd54215939ef0a528434ee026c64ff645148c for docker:20.10.5-dind with digest docker@sha256:e4ecd4e9ad5140d584669451b05e406d8cf7603e51972b862178ad93c38b2b08 ...
Waiting for services to be up and running (timeout 30 seconds)...
*** WARNING: Service runner-spkcd9jk-project-1-concurrent-0-44e1018f87733363-docker-0 probably didn't start properly.
Health check error:
service "runner-spkcd9jk-project-1-concurrent-0-44e1018f87733363-docker-0-wait-for-service" timeout
Health check container logs:
2024-02-13T19:48:22.234554490Z waiting for TCP connection to 172.17.0.3 on [2375 2376]...
2024-02-13T19:48:22.234628336Z dialing 172.17.0.3:2376...
2024-02-13T19:48:22.234693127Z dialing 172.17.0.3:2375...
2024-02-13T19:48:23.235011568Z dialing 172.17.0.3:2376...
2024-02-13T19:48:23.235028828Z dialing 172.17.0.3:2375...
2024-02-13T19:48:24.235313906Z dialing 172.17.0.3:2376...
2024-02-13T19:48:24.235356694Z dialing 172.17.0.3:2375...
2024-02-13T19:48:25.235722846Z dialing 172.17.0.3:2376...
2024-02-13T19:48:25.235821235Z dialing 172.17.0.3:2375...
Service container logs:
2024-02-13T19:48:21.817331815Z Generating RSA private key, 4096 bit long modulus (2 primes)
2024-02-13T19:48:21.928590178Z ..............................++++
2024-02-13T19:48:22.436446184Z ...........................................................................................................................................++++
2024-02-13T19:48:22.436858964Z e is 65537 (0x010001)
2024-02-13T19:48:22.449700309Z Generating RSA private key, 4096 bit long modulus (2 primes)
2024-02-13T19:48:23.210459150Z ........................................................................................................................................................................................................................++++
2024-02-13T19:48:23.465758582Z ..........................................................................++++
2024-02-13T19:48:23.466189197Z e is 65537 (0x010001)
2024-02-13T19:48:23.489792464Z Signature ok
2024-02-13T19:48:23.489811735Z subject=CN = docker:dind server
2024-02-13T19:48:23.489921519Z Getting CA Private Key
2024-02-13T19:48:23.500897024Z /certs/server/cert.pem: OK
2024-02-13T19:48:23.504071151Z Generating RSA private key, 4096 bit long modulus (2 primes)
2024-02-13T19:48:24.139738858Z ............................................................................................................................................................................................++++
2024-02-13T19:48:24.262488117Z ...................................++++
2024-02-13T19:48:24.262939060Z e is 65537 (0x010001)
2024-02-13T19:48:24.284774077Z Signature ok
2024-02-13T19:48:24.284786995Z subject=CN = docker:dind client
2024-02-13T19:48:24.284932635Z Getting CA Private Key
2024-02-13T19:48:24.295231126Z /certs/client/cert.pem: OK
2024-02-13T19:48:24.297914264Z mount: permission denied (are you root?)
2024-02-13T19:48:24.298014976Z Could not mount /sys/kernel/security.
2024-02-13T19:48:24.298029816Z AppArmor detection and --privileged mode might break.
2024-02-13T19:48:24.299008201Z mount: permission denied (are you root?)
*********
Pulling docker image docker:20.10.5 ...
Using docker image sha256:1588477122de4fdfe9fcb9ddeeee6ac6b93e9e05a65c68a6e22add0a98b8e0fe for docker:20.10.5 with digest docker@sha256:7ed427295687586039ff3433bb9b4419c5cf1e6294025dadf7641126665a78f5 ...
Preparing environment
00:00
Running on runner-spkcd9jk-project-1-concurrent-0 via 352e83574200...
Getting source from Git repository
00:01
Fetching changes with git depth set to 20...
Reinitialized existing Git repository in /builds/lanc1k/myproject/.git/
Checking out fdc29e66 as detached HEAD (ref is main)...
Skipping Git submodules setup
Executing "step_script" stage of the job script
00:02
Using docker image sha256:1588477122de4fdfe9fcb9ddeeee6ac6b93e9e05a65c68a6e22add0a98b8e0fe for docker:20.10.5 with digest docker@sha256:7ed427295687586039ff3433bb9b4419c5cf1e6294025dadf7641126665a78f5 ...
$ docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
WARNING! Using --password via the CLI is insecure. Use --password-stdin.
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store
Login Succeeded
$ docker build -t $CI_REGISTRY/$CI_PROJECT_PATH/hello:gitlab-$CI_COMMIT_SHORT_SHA .
#1 [internal] load build definition from Dockerfile
#1 sha256:b9d735c8cbe4a04699f629c4cbcbff2f15c3088408911d316f814c24305d5bd4
#1 transferring dockerfile: 278B done
#1 DONE 0.0s
#2 [internal] load metadata for docker.io/library/centos:7
#2 sha256:30875b35a89c8e8a29cd7cf120689bb68cdab8d769419707e07138dfe977d237
#2 DONE 0.5s
#3 [internal] load .dockerignore
#3 sha256:0b6ead07993a7145244635a12af5c83bf715fcdcd7cbcff9ed5c72cd9a38f578
#3 transferring context: 2B done
#3 DONE 0.0s
#10 [1/6] FROM docker.io/library/centos:7@sha256:be65f488b7764ad3638f236b7b515b3678369a5124c47b8d32916d6487418ea4
#10 sha256:8aee2df8eae94a334b616b2360efaff20c8e0722b9e9251907e0264f86e84fe1
#10 DONE 0.0s
#8 [internal] load build context
#8 sha256:6259709fa58318696cb8f4800efd4ff3ace9b86c97e72f7cef2f2901c75f770d
#8 transferring context: 508B done
#8 DONE 0.0s
#9 [2/6] RUN yum install python3 python3-pip -y
#9 sha256:f1144206e2c393ce7dae78da202bcabe051960e4ee53a33abc414e5f30a9c4cd
#9 CACHED
#7 [3/6] COPY requirements.txt requirements.txt
#7 sha256:d8caeb31264a9b33a0807592bd6671523a6bd19bbcde7f624a2f2d440d0527c4
#7 CACHED
#5 [5/6] WORKDIR /python_api
#5 sha256:436bed81aec05fa5989e3df9fbd49e28ed4cc26a37b4d68785efb7e3f9da2a82
#5 CACHED
#6 [4/6] RUN pip3 install -r requirements.txt
#6 sha256:ff09d258cb9f881d81303722bda944a360751b8cbc5f73ca621e56a75cf8c346
#6 CACHED
#4 [6/6] COPY python-api.py /python_api/python-api.py
#4 sha256:93c8ff72d295df46e36b0cb90022f9381ddf0f4b9fcc6907872a6238001e77d0
#4 CACHED
#11 exporting to image
#11 sha256:ac5f5122001dc517744c481da3c72232f8796a52044f1773bc877f44b64480da
#11 exporting layers done
#11 writing image sha256:c312202380e389ea05ced3ed3eaa3ead34fd571b2dd6676ccc39788397fbd0e4 done
#11 naming to lanc1k.gitlab.yandexcloud.net:5050/lanc1k/myproject/hello:gitlab-fdc29e66 done
#11 DONE 0.0s
$ docker push $CI_REGISTRY/$CI_PROJECT_PATH/hello:gitlab-$CI_COMMIT_SHORT_SHA
The push refers to repository [lanc1k.gitlab.yandexcloud.net:5050/lanc1k/myproject/hello]
f6d1af71e689: Preparing
de5bf1dbbf4b: Preparing
a64518b151f3: Preparing
8a452fd90747: Preparing
5a120754344a: Preparing
174f56854903: Preparing
174f56854903: Waiting
de5bf1dbbf4b: Layer already exists
8a452fd90747: Layer already exists
a64518b151f3: Layer already exists
174f56854903: Layer already exists
5a120754344a: Layer already exists
f6d1af71e689: Pushed
gitlab-fdc29e66: digest: sha256:c7b5d087133a14dc80851ee7a444b300d39ec36bd1d4806f8ee1ca4843845eda size: 1573
Cleaning up project directory and file based variables
00:01
Job succeeded
```
</details>

### Tester


<details><summary>Возврат метода внутри контейнера</summary>

```console
lanc1k@lanc1k-VirtualBox:~$ sudo docker run -p 5290 -d lanc1k.gitlab.yandexcloud.net:5050/lanc1k/myproject/hello:gitlab-fdc29e66

[sudo] пароль для lanc1k: 

Unable to find image 'lanc1k.gitlab.yandexcloud.net:5050/lanc1k/myproject/hello:gitlab-fdc29e66' locally

gitlab-fdc29e66: Pulling from lanc1k/myproject/hello

2d473b07cdd5: Already exists 

55a0a9031c31: Already exists 

afa11c077558: Already exists 

87134daa3598: Already exists 

7daf521d78a7: Already exists 

30fd0cea033f: Pull complete 

Digest: sha256:c7b5d087133a14dc80851ee7a444b300d39ec36bd1d4806f8ee1ca4843845eda

Status: Downloaded newer image for lanc1k.gitlab.yandexcloud.net:5050/lanc1k/myproject/hello:gitlab-fdc29e66

e4dbedbb9b283136e7a826b540d620ea82449850591c45db22c33eb99b319302

lanc1k@lanc1k-VirtualBox:~$ sudo docker ps -a

CONTAINER ID   IMAGE                                                                       COMMAND                  CREATED             STATUS                         PORTS                                         NAMES

e4dbedbb9b28   lanc1k.gitlab.yandexcloud.net:5050/lanc1k/myproject/hello:gitlab-fdc29e66   "python3 /python_api…"   43 seconds ago      Up 43 seconds                  0.0.0.0:32768->5290/tcp, :::32768->5290/tcp   practical_chebyshev

5115054d32b6   lanc1k.gitlab.yandexcloud.net:5050/lanc1k/myproject/hello:gitlab-de5d6870   "/bin/bash"              About an hour ago   Exited (0) About an hour ago                                                 suspicious_shannon

1a66b3002d24   aragast/netology:latest                                                     "/bin/bash"              4 days ago          Exited (0) 4 days ago                                                        relaxed_hugle

b1e81f37288e   aragast/netology:latest                                                     "/bin/bash"              4 days ago          Exited (0) 4 days ago                                                        interesting_wilbur

7a24a14838df   aragast/netology:latest                                                     "/bin/bash"              4 days ago          Exited (130) 4 days ago                                                      peaceful_volhard

46b063297b49   aragast/netology:latest                                                     "/bin/bash"              4 days ago          Exited (2) 4 days ago                                                        cranky_jang

876c58a20679   aragast/netology:latest                                                     "/bin/bash"              4 days ago          Exited (2) 4 days ago                                                        upbeat_galois

c7380a1f7277   aragast/netology:latest                                                     "/bin/bash"              4 days ago          Exited (1) 4 days ago                                                        eager_swanson

af61e4c0a3cb   aragast/netology:latest                                                     "/bin/bash"              4 days ago          Exited (0) 4 days ago                                                        adoring_bhaskara

96ba6b28831b   aragast/netology:latest                                                     "/bin/bash"              4 days ago          Exited (130) 4 days ago                                                      adoring_shirley

6ec82dee8c26   aragast/netology:latest                                                     "/bin/bash"              4 days ago          Exited (127) 4 days ago                                                      stoic_fermi

684aa4e3c3e9   nginx                                                                       "/docker-entrypoint.…"   4 days ago          Exited (1) 4 days ago                                                        warp-warp-demo-nginx-1

f5a9b01b2d55   warp-warp-demo-wsgi                                                         "uwsgi warp_uwsgi.ini"   4 days ago          Exited (127) 4 days ago                                                      warp-warp-demo-wsgi-1

8a34b5e51a73   postgres                                                                    "docker-entrypoint.s…"   4 days ago          Exited (0) 4 days ago                                                        warp-warp-demo-db-1

615510f698e1   ubuntu                                                                      "/bin/bash"              4 weeks ago         Exited (127) 4 weeks ago                                                     determined_bartik

ef972fd7c5ed   ubuntu                                                                      "/bin/bash"              4 weeks ago         Exited (0) 4 weeks ago                                                       recursing_ellis

9b7da024c543   ubuntu                                                                      "/bin/bash"              7 weeks ago         Exited (127) 7 weeks ago                                                     elastic_jang

lanc1k@lanc1k-VirtualBox:~$ sudo docker exec -it e4dbedbb9b28 /bin/bash

[root@e4dbedbb9b28 python_api]# curl localhost:5290/get_info   

{"version": 3, "method": "GET", "message": "Running"}

[root@e4dbedbb9b28 python_api]#
```
</details>