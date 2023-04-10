### 1. Какого типа команда cd? Попробуйте объяснить, почему она именно такого типа: опишите ход своих мыслей и поясните, если считаете, что она могла бы быть другого типа.

`Команда собой представляет команду оболочки командной строки, основное её предназначение - изменение текущего рабочего каталога.`

---

### 2. Какая альтернатива без pipe для команды grep <some_string> <some_file> | wc -l?

`Команда выводит количество совпадений по искомому значению в файле. Альтернатива без pipe - использовать ключ для grep -c. В моём случае команда выглядела так: grep 2 \{1..100000.txt\} -c`

---

### 3. Какой процесс с PID 1 является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?

`Процесс с PID 1 - systemd`

> systemd(1)─┬─ModemManager(787)─┬─{ModemManager}(809)
           │                   └─{ModemManager}(822)
           ├─VBoxDRMClient(907)─┬─{VBoxDRMClient}(912)
           │                    ├─{VBoxDRMClient}(914)
           │                    └─{VBoxDRMClient}(915)
           ├─VBoxService(913)─┬─{VBoxService}(916)
           │                  ├─{VBoxService}(917)
           │                  ├─{VBoxService}(918)
           │                  ├─{VBoxService}(919)
           │                  ├─{VBoxService}(920)
           │                  ├─{VBoxService}(921)
           │                  ├─{VBoxService}(922)
           │                  └─{VBoxService}(923)

---
### 4. Как будет выглядеть команда, которая перенаправит вывод stderr ls на другую сессию терминала?

`ls /asd/fsfg/asdf 2>/dev/pts/1`

---

### 5. Получится ли одновременно передать команде файл на stdin и вывести её stdout в другой файл? Приведите работающий пример.

`ls -alt | tee output.txt`

```
vagrant@vagrant:~$ ls -alt | tee output.txt
total 2808
drwxr-xr-x 6 vagrant vagrant 2797568 Apr 10 20:31 .
-rw-rw-r-- 1 vagrant vagrant       0 Apr 10 20:31 output.txt
drwx------ 3 vagrant vagrant    4096 Apr 10 19:09 .config
-rw------- 1 vagrant vagrant     198 Apr 10 19:08 .lesshst
-rw------- 1 vagrant vagrant    1967 Apr 10 19:01 .viminfo
-rw-rw-r-- 1 vagrant vagrant      16 Apr 10 19:01 {1..100000.txt}
-rw------- 1 vagrant vagrant    1055 Mar 30 16:42 .bash_history
drwxrwxr-x 3 vagrant vagrant    4096 Mar 26 20:56 .local
-rw-r--r-- 1 vagrant vagrant   12484 Mar 26 14:14 sf
drwx------ 2 vagrant vagrant    4096 Mar 23 20:15 .ssh
-rw-r--r-- 1 root    root        180 Mar 14 22:03 .wget-hsts
-rw-r--r-- 1 vagrant vagrant       0 Mar 14 21:58 .sudo_as_admin_successful
-rw-r--r-- 1 vagrant vagrant       5 Mar 14 21:58 .vbox_version
drwx------ 2 vagrant vagrant    4096 Mar 14 21:58 .cache
drwxr-xr-x 3 root    root       4096 Mar 14 21:57 ..
-rw-r--r-- 1 vagrant vagrant     220 Feb 25  2020 .bash_logout
-rw-r--r-- 1 vagrant vagrant    3771 Feb 25  2020 .bashrc
-rw-r--r-- 1 vagrant vagrant     807 Feb 25  2020 .profile
```

---

### 6. 


