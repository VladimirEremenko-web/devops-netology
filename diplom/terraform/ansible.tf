resource "local_file" "hosts_cfg_kubespray" {
  count = var.exclude_ansible ? 0 : 1 # Если exclude_ansible true, ресурс не создается

  content = templatefile("${path.module}/hosts.tftpl", {
    workers = yandex_compute_instance.worker
    masters = yandex_compute_instance.master
  })
  filename = "/home/lanc1k/lessons/kubespray/inventory/mycluster/hosts.yaml"
}
