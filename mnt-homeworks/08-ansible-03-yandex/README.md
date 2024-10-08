# Домашнее задание к занятию 3 «Использование Ansible»

## Описание проекта

1. Инфраструктура проекта:
 - Сервер `clickhouse-01` служит для установки и эксплуатации БД
 - Сервер `vector-01` - развёрнут vector.service для сбора и обработки логов с последующей отправкой в БД на сервере `clickhouse-01`
 - Сервер `lighthouse-01` - устанавливает Nginx и разворачивается Lighthouse

2. Playbook

- ### Clickhouse

  - Скачивание пакетов и установка `clickhouse`
  - создание базы данных и таблицы в ней

- ### Vector

  - Создание группы пользователей
  - Создание пользователя
  - Создание путей для исполняемых файлов
  - Проверка корректности путей
  - Проверка версии Vector
  - Скачивание и установка Vector
  - Подстановка шаблонов файлов конфигурации

- ### Lighthouse

  1. Play установки Nginx
    - Устанавливается nginx и git, вызывается хэндлер на старт сервиса
    - Устанавливается конфиг nginx. Вызывается хэндлер на перезагрузку сервиса
  2. Play установки Lighthouse
    - С гита на целевой хост скачивается репозиторий lighthouse из ветки master
    - Подставляется конфиг lighthouse
3. Variables

В папке group_vars созданы файлы с переменными для `clickhouse-01`, `vector-01` и `lighthouse-01`

4. Исполнение playbook

```
anc1k@lanc1k-VirtualBox:~/lessons/netolessondz/ansible-homeworks/mnt-homeworks/08-ansible-02-playbook/playbook$ ansible-playbook -i inventory/prod.yml site.yml --diff

PLAY [Install Clickhouse] ***************************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] ***********************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
ok: [clickhouse-01] => (item=clickhouse-common-static)

TASK [Install clickhouse packages] ******************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Flush handlers] *******************************************************************************************************************************************************************************

TASK [Clickhouse pause] *****************************************************************************************************************************************************************************
Pausing for 5 seconds
(ctrl+C then 'C' = continue early, ctrl+C then 'A' = abort)
ok: [clickhouse-01]

TASK [Create database] ******************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create log table] *****************************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install vector] *******************************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Install | Ensure vector group] ****************************************************************************************************************************************************************
ok: [vector-01]

TASK [Install | Ensure vector user] *****************************************************************************************************************************************************************
ok: [vector-01]

TASK [Install | Ensure skeleton paths] **************************************************************************************************************************************************************
ok: [vector-01] => (item=/usr/bin)

TASK [Install | Check that the "/usr/bin/vector" exists] ********************************************************************************************************************************************
ok: [vector-01]

TASK [Install | Check vector version] ***************************************************************************************************************************************************************
ok: [vector-01]

TASK [Install | Download package] *******************************************************************************************************************************************************************
ok: [vector-01]

TASK [Install | Installation vector packages] *******************************************************************************************************************************************************
skipping: [vector-01]

TASK [config | Configure vector] ********************************************************************************************************************************************************************
ok: [vector-01]

TASK [Copy daemon script] ***************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Configure service] ****************************************************************************************************************************************************************************
ok: [vector-01]

PLAY [install nginx] ********************************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Install nginx and git] ************************************************************************************************************************************************************************
The following additional packages will be installed:
  libnginx-mod-http-geoip2 libnginx-mod-http-image-filter
  libnginx-mod-http-xslt-filter libnginx-mod-mail libnginx-mod-stream
  libnginx-mod-stream-geoip2 nginx-common nginx-core
Suggested packages:
  fcgiwrap nginx-doc ssl-cert
The following NEW packages will be installed:
  libnginx-mod-http-geoip2 libnginx-mod-http-image-filter
  libnginx-mod-http-xslt-filter libnginx-mod-mail libnginx-mod-stream
  libnginx-mod-stream-geoip2 nginx nginx-common nginx-core
Preconfiguring packages ...
0 upgraded, 9 newly installed, 0 to remove and 3 not upgraded.
changed: [lighthouse-01]

TASK [set config nginx] *****************************************************************************************************************************************************************************
--- before: /etc/nginx/nginx.conf
+++ after: /home/lanc1k/.ansible/tmp/ansible-local-10305lz5tafgu/tmpi4ge20t7/nginx.conf.j2
@@ -1,83 +1,46 @@
-user www-data;
-worker_processes auto;
-pid /run/nginx.pid;
-include /etc/nginx/modules-enabled/*.conf;
+user  www-data;
+worker_processes  1;
+worker_priority     -1;
+
+error_log  /var/log/nginx/error.log warn;
+pid        /var/run/nginx.pid;
 
 events {
-       worker_connections 768;
-       # multi_accept on;
+    worker_connections  1024;
 }
 
 http {
+    include       /etc/nginx/mime.types;
+    default_type  application/octet-stream;
 
-       ##
-       # Basic Settings
-       ##
+    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
+                      '$status $body_bytes_sent "$http_referer" '
+                      '"$http_user_agent" "$http_x_forwarded_for"';
+    access_log  /var/log/nginx/access.log  main;
 
-       sendfile on;
-       tcp_nopush on;
-       types_hash_max_size 2048;
-       # server_tokens off;
+    sendfile on;
+    tcp_nopush on;
+    tcp_nodelay on;
+    keepalive_timeout  65;
+    reset_timedout_connection  on;
+    client_body_timeout        35;
+    send_timeout               30;
 
-       # server_names_hash_bucket_size 64;
-       # server_name_in_redirect off;
+    gzip on;
+    gzip_min_length     1000;
+    gzip_vary on;
+    gzip_proxied        expired no-cache no-store private auth;
+    gzip_types          text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript application/javascript;
+    gzip_disable        "msie6";
 
-       include /etc/nginx/mime.types;
-       default_type application/octet-stream;
+    types_hash_max_size 2048;
+    client_max_body_size 1024;
+    proxy_buffer_size   64k;
+    proxy_buffers   4 64k;
+    proxy_busy_buffers_size   64k;
+    server_names_hash_bucket_size 64;
 
-       ##
-       # SSL Settings
-       ##
-
-       ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
-       ssl_prefer_server_ciphers on;
-
-       ##
-       # Logging Settings
-       ##
-
-       access_log /var/log/nginx/access.log;
-       error_log /var/log/nginx/error.log;
-
-       ##
-       # Gzip Settings
-       ##
-
-       gzip on;
-
-       # gzip_vary on;
-       # gzip_proxied any;
-       # gzip_comp_level 6;
-       # gzip_buffers 16 8k;
-       # gzip_http_version 1.1;
-       # gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
-
-       ##
-       # Virtual Host Configs
-       ##
-
-       include /etc/nginx/conf.d/*.conf;
-       include /etc/nginx/sites-enabled/*;
-}
-
-
-#mail {
-#      # See sample authentication script at:
-#      # http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript
-#
-#      # auth_http localhost/auth.php;
-#      # pop3_capabilities "TOP" "USER";
-#      # imap_capabilities "IMAP4rev1" "UIDPLUS";
-#
-#      server {
-#              listen     localhost:110;
-#              protocol   pop3;
-#              proxy      on;
-#      }
-#
-#      server {
-#              listen     localhost:143;
-#              protocol   imap;
-#              proxy      on;
-#      }
-#}
+    include /etc/nginx/modules-enabled/*.conf;
+    include /etc/nginx/conf.d/*.conf;
+    include /etc/nginx/sites-enabled/*;
+}
\ No newline at end of file

changed: [lighthouse-01]

RUNNING HANDLER [start-nginx] ***********************************************************************************************************************************************************************
ok: [lighthouse-01]

RUNNING HANDLER [reload-nginx] **********************************************************************************************************************************************************************
changed: [lighthouse-01]

PLAY [install lighthouse] ***************************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [lighthouse | Copy from git] *******************************************************************************************************************************************************************
>> Newly checked out d701335c25cd1bb9b5155711190bad8ab852c2ce
changed: [lighthouse-01]

TASK [lighthouse | set config site] *****************************************************************************************************************************************************************
--- before
+++ after: /home/lanc1k/.ansible/tmp/ansible-local-10305lz5tafgu/tmpr_oiph_r/lighthouse.conf.j2
@@ -0,0 +1,20 @@
+server {
+    listen 8080;
+    server_name  0.0.0.0;
+    root /home/usert/lighthouse/;
+
+    access_log /var/log/nginx/lighthouse_access_log;
+    error_log /var/log/nginx/lighthouse_error_log;
+
+    location / {
+        proxy_redirect     off;
+        proxy_set_header   Host             $host;
+        proxy_set_header   X-Forwarded-Proto $scheme;
+        proxy_set_header   X-Real-IP        $remote_addr;
+        proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
+    }
+    
+    location ~* ^.+\.(jpg|jpeg|gif|png|css|zip|tgz|gz|rar|bz2|doc|docx|xls|xlsx|exe|pdf|ppt|tar|wav|bmp|rtf|js)$ {
+            expires modified +1w;
+    }
+}
\ No newline at end of file

changed: [lighthouse-01]

RUNNING HANDLER [reload-nginx] **********************************************************************************************************************************************************************
changed: [lighthouse-01]

PLAY RECAP ******************************************************************************************************************************************************************************************
clickhouse-01              : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
lighthouse-01              : ok=9    changed=6    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=10   changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0 

```