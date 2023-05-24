data "yandex_compute_image" "lemp" {
  family = "lemp"
}

resource "yandex_compute_instance" "vm-test1" {
  name                      = "web1"
  allow_stopping_for_update = true
  hostname = "web1.test.netology"
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.lemp.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
    #security_group_ids  = [yandex_vpc_security_group.in_sg.id]
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }
}


resource "yandex_compute_instance" "vm-test2" {
  name                      = "web2"
  allow_stopping_for_update = true
  hostname = "web2.test.netology"
  platform_id = "standard-v1"
  zone = "ru-central1-b"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.lemp.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-2.id
    nat       = true
    #security_group_ids  = [yandex_vpc_security_group.in_sg.id]
  }
  metadata = {
    user-data = "${file("./meta.yml")}"
  }
}


data "yandex_compute_image" "debian-11" {
  family = "debian-11"
}

resource "yandex_compute_instance" "vm-3" {
  name                      = "prom"
  allow_stopping_for_update = true
  hostname = "prom.test.netology"
  platform_id = "standard-v1"

resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8fphfpeqijnlu1phu4"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
    #security_group_ids  = [yandex_vpc_security_group.in_sg.id]

  }
  metadata = {
    user-data = "${file("./meta.yml")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
  description = "My first network"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["10.128.0.0/24"]
  #route_table_id = yandex_vpc_route_table.lab-rt-a.id
}

resource "yandex_vpc_subnet" "subnet-2" {
  name           = "subnet2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["10.129.0.0/24"]
  #route_table_id = yandex_vpc_route_table.lab-rt-a.id
}




#resource "yandex_vpc_subnet" "subnet_terraform" {
#  name           = "subnet_terraform"
#  zone           = "ru-central1-a"
#  network_id     = yandex_vpc_network.network_terraform.id
#  v4_cidr_blocks = ["192.168.15.0/24"]
#}







#resource "yandex_lb_network_load_balancer" "lb-test" {
#  name = "lb-test"
#  listener {
#    name = "listener-web-servers"
#    port = 80
#    external_address_spec {
#      ip_version = "ipv4"
#    }
#  }

#  attached_target_group {
#    target_group_id = yandex_lb_target_group.web-servers.id

#    healthcheck {
#      name = "http"
#      http_options {
#        port = 80
#        path = "/"
#      }
#    }
#  }
#}





