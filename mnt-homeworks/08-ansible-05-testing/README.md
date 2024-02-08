# Домашнее задание к занятию 5 «Тестирование roles»

## Molecule

2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.

![Скриншот](./images/molecule%20init.jpg)

3. Добавьте несколько разных дистрибутивов для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.

```yaml
platforms:
  - name: centos:8
    image: docker.io/pycontribs/centos:8
    pre_build_image: true
  - name: ubuntu:latest
    image: docker.io/pycontribs/ubuntu:latest
    pre_build_image: true
```
</details>

<details><summary>molecule test</summary>

```console
lanc1k@lanc1k-VirtualBox:~/lessons/netolessondz/ansible-homeworks/mnt-homeworks/08-ansible-05-testing/homework$ sudo molecule test
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/home/lanc1k/.cache/ansible-compat/882b46/modules:/home/lanc1k/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/lanc1k/.cache/ansible-compat/882b46/collections:/home/lanc1k/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/lanc1k/.cache/ansible-compat/882b46/roles:/home/lanc1k/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
INFO     Lint is disabled.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the 
controller starting with Ansible 2.12. Current version: 3.7.3 (default, Oct 11 
2023, 09:51:27) [GCC 8.3.0]. This feature will be removed from ansible-core in 
version 2.12. Deprecation warnings can be disabled by setting 
deprecation_warnings=False in ansible.cfg.

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=centos8)
ok: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the 
controller starting with Ansible 2.12. Current version: 3.7.3 (default, Oct 11 
2023, 09:51:27) [GCC 8.3.0]. This feature will be removed from ansible-core in 
version 2.12. Deprecation warnings can be disabled by setting 
deprecation_warnings=False in ansible.cfg.

playbook: /home/lanc1k/lessons/netolessondz/ansible-homeworks/mnt-homeworks/08-ansible-05-testing/homework/molecule/default/converge.yml
INFO     Running default > create
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the 
controller starting with Ansible 2.12. Current version: 3.7.3 (default, Oct 11 
2023, 09:51:27) [GCC 8.3.0]. This feature will be removed from ansible-core in 
version 2.12. Deprecation warnings can be disabled by setting 
deprecation_warnings=False in ansible.cfg.

PLAY [Create] ******************************************************************

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}) 
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}) 

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:8) 
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/ubuntu:latest) 

TASK [Create docker network(s)] ************************************************

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '499431011507.144704', 'results_file': '/home/lanc1k/.ansible_async/499431011507.144704', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '369947400393.144732', 'results_file': '/home/lanc1k/.ansible_async/369947400393.144732', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=5    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the 
controller starting with Ansible 2.12. Current version: 3.7.3 (default, Oct 11 
2023, 09:51:27) [GCC 8.3.0]. This feature will be removed from ansible-core in 
version 2.12. Deprecation warnings can be disabled by setting 
deprecation_warnings=False in ansible.cfg.

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [ubuntu]
ok: [centos8]

TASK [Include vector] **********************************************************

TASK [vector : Create directory vector] ****************************************
changed: [ubuntu]
changed: [centos8]

TASK [vector : Get vector distrib] *********************************************
changed: [ubuntu]
changed: [centos8]

TASK [vector : Unarchive vector] ***********************************************
changed: [ubuntu]
changed: [centos8]

TASK [vector : Create a symbolic link] *****************************************
changed: [centos8]
changed: [ubuntu]

TASK [vector : Create vector unit flie] ****************************************
changed: [centos8]
changed: [ubuntu]

TASK [vector : Mkdir vector data] **********************************************
changed: [centos8]
changed: [ubuntu]

TASK [vector : Vector config create] *******************************************
changed: [ubuntu]
changed: [centos8]

TASK [vector : Configuring service vector] *************************************
skipping: [centos8]
skipping: [ubuntu]

PLAY RECAP *********************************************************************
centos8                    : ok=8    changed=7    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
ubuntu                     : ok=8    changed=7    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > idempotence
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the 
controller starting with Ansible 2.12. Current version: 3.7.3 (default, Oct 11 
2023, 09:51:27) [GCC 8.3.0]. This feature will be removed from ansible-core in 
version 2.12. Deprecation warnings can be disabled by setting 
deprecation_warnings=False in ansible.cfg.

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos8]
ok: [ubuntu]

TASK [Include vector] **********************************************************

TASK [vector : Create directory vector] ****************************************
ok: [centos8]
ok: [ubuntu]

TASK [vector : Get vector distrib] *********************************************
ok: [ubuntu]
ok: [centos8]

TASK [vector : Unarchive vector] ***********************************************
skipping: [centos8]
skipping: [ubuntu]

TASK [vector : Create a symbolic link] *****************************************
ok: [centos8]
ok: [ubuntu]

TASK [vector : Create vector unit flie] ****************************************
ok: [ubuntu]
ok: [centos8]

TASK [vector : Mkdir vector data] **********************************************
ok: [ubuntu]
ok: [centos8]

TASK [vector : Vector config create] *******************************************
ok: [ubuntu]
ok: [centos8]

TASK [vector : Configuring service vector] *************************************
skipping: [centos8]
skipping: [ubuntu]

PLAY RECAP *********************************************************************
centos8                    : ok=7    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
ubuntu                     : ok=7    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running default > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running default > verify
INFO     Running Ansible Verifier
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the 
controller starting with Ansible 2.12. Current version: 3.7.3 (default, Oct 11 
2023, 09:51:27) [GCC 8.3.0]. This feature will be removed from ansible-core in 
version 2.12. Deprecation warnings can be disabled by setting 
deprecation_warnings=False in ansible.cfg.

PLAY [Verify] ******************************************************************

TASK [Example assertion] *******************************************************
ok: [ubuntu] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [centos8] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
centos8                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the 
controller starting with Ansible 2.12. Current version: 3.7.3 (default, Oct 11 
2023, 09:51:27) [GCC 8.3.0]. This feature will be removed from ansible-core in 
version 2.12. Deprecation warnings can be disabled by setting 
deprecation_warnings=False in ansible.cfg.

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```
</details>

4. Добавьте несколько assert в verify.yml-файл для проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.).

</details>

<details><summary>Дополненный Verify</summary>

```yaml
- name: Verify
  hosts: all
  gather_facts: false
  vars_files:
    -  "{{ lookup('ansible.builtin.env', 'MOLECULE_PROJECT_DIRECTORY') }}/vars/main.yml"
  tasks:

  - name: Get Vector version
    ansible.builtin.command: "vector --version"
    changed_when: false
    register: vector_version
  - name: Assert Vector instalation
    assert:
      that: "'{{ vector_version.rc }}' == '0'"

  - name: Validation Vector configuration
    ansible.builtin.command: "vector validate --no-environment --config-toml {{ vector_config }}"
    changed_when: false
    register: vector_validate
  - name: Assert Vector validate config
    assert:
      that: "'{{ vector_validate.rc }}' == '0'"
```
</details>

5. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.

</details>

<details><summary>Повторил тест</summary>

lanc1k@lanc1k-VirtualBox:~/lessons/netolessondz/ansible-homeworks/mnt-homeworks/08-ansible-05-testing/homework$ sudo molecule test
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/home/lanc1k/.cache/ansible-compat/882b46/modules:/home/lanc1k/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/lanc1k/.cache/ansible-compat/882b46/collections:/home/lanc1k/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/lanc1k/.cache/ansible-compat/882b46/roles:/home/lanc1k/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
INFO     Lint is disabled.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the 
controller starting with Ansible 2.12. Current version: 3.7.3 (default, Oct 11 
2023, 09:51:27) [GCC 8.3.0]. This feature will be removed from ansible-core in 
version 2.12. Deprecation warnings can be disabled by setting 
deprecation_warnings=False in ansible.cfg.

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=centos8)
ok: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the 
controller starting with Ansible 2.12. Current version: 3.7.3 (default, Oct 11 
2023, 09:51:27) [GCC 8.3.0]. This feature will be removed from ansible-core in 
version 2.12. Deprecation warnings can be disabled by setting 
deprecation_warnings=False in ansible.cfg.

playbook: /home/lanc1k/lessons/netolessondz/ansible-homeworks/mnt-homeworks/08-ansible-05-testing/homework/molecule/default/converge.yml
INFO     Running default > create
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the 
controller starting with Ansible 2.12. Current version: 3.7.3 (default, Oct 11 
2023, 09:51:27) [GCC 8.3.0]. This feature will be removed from ansible-core in 
version 2.12. Deprecation warnings can be disabled by setting 
deprecation_warnings=False in ansible.cfg.

PLAY [Create] ******************************************************************

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}) 
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}) 

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:8) 
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/ubuntu:latest) 

TASK [Create docker network(s)] ************************************************

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) creation to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '285112306589.217797', 'results_file': '/home/lanc1k/.ansible_async/285112306589.217797', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '479806471625.217825', 'results_file': '/home/lanc1k/.ansible_async/479806471625.217825', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=5    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the 
controller starting with Ansible 2.12. Current version: 3.7.3 (default, Oct 11 
2023, 09:51:27) [GCC 8.3.0]. This feature will be removed from ansible-core in 
version 2.12. Deprecation warnings can be disabled by setting 
deprecation_warnings=False in ansible.cfg.

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [ubuntu]
ok: [centos8]

TASK [Include vector] **********************************************************

TASK [vector : Create directory vector] ****************************************
changed: [ubuntu]
changed: [centos8]

TASK [vector : Get vector distrib] *********************************************
changed: [ubuntu]
changed: [centos8]

TASK [vector : Unarchive vector] ***********************************************
changed: [ubuntu]
changed: [centos8]

TASK [vector : Create a symbolic link] *****************************************
changed: [ubuntu]
changed: [centos8]

TASK [vector : Create vector unit flie] ****************************************
changed: [ubuntu]
changed: [centos8]

TASK [vector : Mkdir vector data] **********************************************
changed: [centos8]
changed: [ubuntu]

TASK [vector : Vector config create] *******************************************
changed: [centos8]
changed: [ubuntu]

TASK [vector : Configuring service vector] *************************************
skipping: [centos8]
skipping: [ubuntu]

PLAY RECAP *********************************************************************
centos8                    : ok=8    changed=7    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
ubuntu                     : ok=8    changed=7    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > idempotence
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the 
controller starting with Ansible 2.12. Current version: 3.7.3 (default, Oct 11 
2023, 09:51:27) [GCC 8.3.0]. This feature will be removed from ansible-core in 
version 2.12. Deprecation warnings can be disabled by setting 
deprecation_warnings=False in ansible.cfg.

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos8]
ok: [ubuntu]

TASK [Include vector] **********************************************************

TASK [vector : Create directory vector] ****************************************
ok: [ubuntu]
ok: [centos8]

TASK [vector : Get vector distrib] *********************************************
ok: [ubuntu]
ok: [centos8]

TASK [vector : Unarchive vector] ***********************************************
skipping: [centos8]
skipping: [ubuntu]

TASK [vector : Create a symbolic link] *****************************************
ok: [ubuntu]
ok: [centos8]

TASK [vector : Create vector unit flie] ****************************************
ok: [ubuntu]
ok: [centos8]

TASK [vector : Mkdir vector data] **********************************************
ok: [centos8]
ok: [ubuntu]

TASK [vector : Vector config create] *******************************************
ok: [centos8]
ok: [ubuntu]

TASK [vector : Configuring service vector] *************************************
skipping: [centos8]
skipping: [ubuntu]

PLAY RECAP *********************************************************************
centos8                    : ok=7    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
ubuntu                     : ok=7    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running default > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running default > verify
INFO     Running Ansible Verifier
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the 
controller starting with Ansible 2.12. Current version: 3.7.3 (default, Oct 11 
2023, 09:51:27) [GCC 8.3.0]. This feature will be removed from ansible-core in 
version 2.12. Deprecation warnings can be disabled by setting 
deprecation_warnings=False in ansible.cfg.

PLAY [Verify] ******************************************************************

TASK [Get Vector version] ******************************************************
ok: [ubuntu]
ok: [centos8]

TASK [Assert Vector instalation] ***********************************************
ok: [centos8] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [ubuntu] => {
    "changed": false,
    "msg": "All assertions passed"
}

TASK [Validation Vector configuration] *****************************************
ok: [centos8]
ok: [ubuntu]

TASK [Assert Vector validate config] *******************************************
ok: [centos8] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [ubuntu] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
centos8                    : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the 
controller starting with Ansible 2.12. Current version: 3.7.3 (default, Oct 11 
2023, 09:51:27) [GCC 8.3.0]. This feature will be removed from ansible-core in 
version 2.12. Deprecation warnings can be disabled by setting 
deprecation_warnings=False in ansible.cfg.

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory

</details>

6. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

