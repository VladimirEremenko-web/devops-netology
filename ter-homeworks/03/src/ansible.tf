resource "local_file" "inventory_cfg" {
  content = templatefile("${path.module}/inventory.tftpl",
    {
      webservers       = yandex_compute_instance.web,
      fe_instance      = yandex_compute_instance.forech_bm,
      storage_instance = [yandex_compute_instance.storage]
    }
  )

  filename = "${abspath(path.module)}/inventory.cfg"
}

resource "null_resource" "web_hosts_provision" {
  #Ждем создания инстанса
  depends_on = [yandex_compute_instance.storage, local_file.inventory_cfg]

  #Даем ВМ 60 сек на первый запуск.
  provisioner "local-exec" {
    command = "sleep 60"
  }

  #Запуск ansible-playbook
  provisioner "local-exec" {
    command     = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -i ${abspath(path.module)}/inventory.cfg ${abspath(path.module)}/test.yml"
    on_failure  = continue #Продолжить выполнение terraform pipeline в случае ошибок
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
    #срабатывание триггера при изменении переменных
  }
  triggers = {
    always_run        = "${timestamp()}"                         #всегда т.к. дата и время постоянно изменяются
    playbook_src_hash = file("${abspath(path.module)}/test.yml") # при изменении содержимого playbook файла
    ssh_public_key    = local.ssh                                # при изменении переменной
  }

}
