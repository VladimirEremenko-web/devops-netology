## Задание 1.

Дайте письменые ответы на вопросы:

1. В чём отличие режимов работы сервисов в Docker Swarm-кластере: replication и global?
2. Какой алгоритм выбора лидера используется в Docker Swarm-кластере?
3. Что такое Overlay Network?

### Ответ

- Сервис в режиме `global` разворачивается с одной репликой на каждом узле кластера который удовлетворяет ограничениям размещения, в режиме `replication` сервисы обычно распределяются по нодам в запрошенном количестве, но также могут быть размещены на одной ноде.
- Используется так называемый алгоритм поддержания распределенного консенсуса — Raft
- Overlay Network создает подсеть, которую могут использовать контейнеры в разных хостах swarm-кластера. Overlay-сеть использует технологию vxlan, которая инкапсулирует layer 2 фреймы в layer 4 пакеты (UDP/IP). При помощи этого действия Docker создает виртуальные сети поверх существующих связей между хостами, которые могут оказаться внутри одной подсети.

## Задание 2.

Создайте ваш первый Docker Swarm-кластер в Яндекс Облаке.

Чтобы получить зачёт, предоставьте скриншот из терминала (консоли) с выводом команды: `docker node ls`

![Скриншот](/05-virt-05-docker-swarm/images/docker%20node%20ls.jpg)

## Задание 3.

Создайте ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Чтобы получить зачёт, предоставьте скриншот из терминала (консоли), с выводом команды: `docker service ls`

![Скриншот](/05-virt-05-docker-swarm/images/docker%20service%20ls.jpg)

## Задание 4. (*)

Выполните на лидере Docker Swarm-кластера команду, указанную ниже, и дайте письменное описание её функционала — что она делает и зачем нужна:

``` 
# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true 
```

### Ответ

- Команда `docker swarm update --autolock=true` создает новый ключ, используемый для шифрования открытых/закрытых ключей, используемых для шифрования/расшифровки журналов. Это нужно для того, что бы Docker смог защитить общий ключ шифрования TLS и ключ, используемый для шифрования и расшифровки журналов Raft, позволяя стать владельцем этих ключей и требовать ручной разблокировки управляющих нод.

Процесс создания ключа, попытка вывода команды где запрашивается ключ и вывод команды после воода ключа на скриншоте ниже:

![Скриншот](/05-virt-05-docker-swarm/images/docker%20swarm%20autolock.jpg)