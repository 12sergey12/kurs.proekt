resource "yandex_alb_target_group" "test-target-group" {
  name           = "ttg"

  target {
    subnet_id    = yandex_vpc_subnet.subnet-1.id
    ip_address   = yandex_compute_instance.vm-test1.network_interface.0.ip_address
  }

  target {
    subnet_id    = yandex_vpc_subnet.subnet-2.id
    ip_address   = yandex_compute_instance.vm-test2.network_interface.0.ip_address
  }
}


resource "yandex_alb_backend_group" "test-backend-group" {
  name                     = "tbg"
  #session_affinity {
    connection {
      source_ip = true
    }
  #}
  http_backend {
    name                   = "test-http-backend"
    weight                 = 1
    port                   = 80
    target_group_ids       = ["${yandex_alb_target_group.test-target-group.id}"]
    load_balancing_config {
      panic_threshold      = 90
    }
    healthcheck {
      timeout              = "180s"
      interval             = "120s"
      healthy_threshold    = 10
      unhealthy_threshold  = 15
      http_healthcheck {
        path               = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "tf-router" {
  name   = "tfr"
  labels = {
    tf-label    = "tf-label-value"
    empty-label = ""
  }
}
resource "yandex_alb_virtual_host" "my-virtual-host" {
  name           = "mvh"
  http_router_id = yandex_alb_http_router.tf-router.id
  route {
    name = "tf-rout"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.test-backend-group.id
        timeout          = "3s"
      }
    }
  }
}

resource "yandex_alb_load_balancer" "test-balancer" {
  name        = "test-balancer"
  network_id  = yandex_vpc_network.network-1.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.subnet-1.id
    }

#    location {
#      zone_id   = "ru-central1-b"
#      subnet_id = yandex_vpc_subnet.subnet-2.id
#    }
  }

  listener {
    name = "my-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 80 ]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.tf-router.id
      }
    }
  }
#  log_options {
#    discard_rule {
#      http_code_intervals = ["HTTP_2XX"]
#      discard_percent = 75
#    }
#  }
}


