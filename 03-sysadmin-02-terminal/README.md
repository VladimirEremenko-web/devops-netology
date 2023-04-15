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

### 6. Получится ли, находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?

Получится, например:

`echo "Hello tty2" > /dev/tty2`

![Скриншот](/03-sysadmin-02-terminal/images/Screenshot.jpg)

### 7. Выполните команду bash 5>&1. К чему она приведёт? Что будет, если вы выполните echo netology > /proc/$$/fd/5? Почему так происходит?

`bash 5>&1`  запускает экземпляр bash с fd 5 и перенаправит его на fd 1 (stdout).

`echo netology > /proc/$$/fd/5` выводит в терминал слово "netology". Это происходит потому что echo отправляет netology в fd 5 текущего шелла, подсистема /proc содержит информацию о запущенных процессах по их PID, $$ - подставит PID текущего шелла

### 8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв отображение stdout на pty?

`cat ~/.bashrc pppsdfqvb 2>&1 1>/dev/pts/0 | sed 's/cat/test/g' > test;`

### 9. Что выведет команда cat /proc/$$/environ? Как ещё можно получить аналогичный по содержанию вывод?

Команда выведет список переменных окружения со значениями, альтернативный вариант `env`

### 10. Используя man, опишите, что доступно по адресам /proc/<PID>/cmdline, /proc/<PID>/exe.

`/proc/[pid]/cmdline` содержит командную строку и аргументы процесса

`/proc/<PID>/exe` это симлинк на полный путь к исполняемому файлу из которого вызвана программа c пидом

### 11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью /proc/cpuinfo.

Версия 4_2

```
vagrant@vagrant:~$ grep sse /proc/cpuinfo
flags         : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid
sse4_1 sse4_2 x2apic popcnt aes xsave avx rdrand hypervisor lahf_lm pti fsgsbase md_clear flush_l1d
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid
sse4_1 sse4_2 x2apic popcnt aes xsave avx rdrand hypervisor lahf_lm pti fsgsbase md_clear flush_l1d
vagrant@vagrant:~$ 
```

### 12. При открытии нового окна терминала и vagrant ssh создаётся новая сессия и выделяется pty.Это можно подтвердить командой tty, которая упоминалась в лекции 3.2.

Это сделано для правильной работы в скриптах. Если сразу выполнить команду на удалённом сервере через ssh. Sshd и запускаемые команды это поймут, поэтому они не будут спрашивать что-то у пользователя, а вывод очистят от лишних данных.
Исправить можно с помощью ключа -T при вызове ssh

### 13. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись reptyr. Например, так можно перенести в screen процесс, который вы запустили по ошибке в обычной SSH-сессии.

Работает, помогла инструкция https://github.com/nelhage/reptyr#typical-usage-pattern

### 14. sudo echo string > /root/new_file не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell, который запущен без sudo под вашим пользователем. Для решения этой проблемы можно использовать конструкцию echo string | sudo tee /root/new_file. Узнайте, что делает команда tee и почему в отличие от sudo echo команда с sudo tee будет работать.

Команда tee делает вывод одновременно и в файл, указанный в качестве параметра, и в stdout. В данном примере команда получает вывод из stdin, перенаправленный через pipe от stdout команды echo и т.к. команда запущена от sudo, соответственно имеет повышенные права на запись.


