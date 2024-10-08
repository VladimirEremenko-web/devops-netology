resource "yandex_lb_target_group" "balancer-group" {
  name       = "balancer-group"
  depends_on = [yandex_compute_instance.master]
  dynamic "target" {
    for_each = yandex_compute_instance.worker
    content {
      subnet_id = target.value.network_interface.0.subnet_id
      address   = target.value.network_interface.0.ip_address
    }
  }
}

# Grafana
resource "yandex_lb_network_load_balancer" "lb-grafana" {
  name = "grafana"
  listener {
    name        = "grafana-listener"
    port        = 3000
    target_port = 30050
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = yandex_lb_target_group.balancer-group.id
    healthcheck {
      name = "healthcheck"
      tcp_options {
        port = 30050
      }
    }
  }
  depends_on = [yandex_lb_target_group.balancer-group]
}

# Приложение
resource "yandex_lb_network_load_balancer" "lb-web-app" {
  name = "web-app"
  listener {
    name        = "web-app-listener"
    port        = 80
    target_port = 30051
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = yandex_lb_target_group.balancer-group.id
    healthcheck {
      name = "healthcheck"
      tcp_options {
        port = 30051
      }
    }
  }
  depends_on = [yandex_lb_network_load_balancer.lb-grafana]
}
