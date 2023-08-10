terraform {
  required_version = "= 1.4.5"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "= 0.73"
    }
  }
}
provider "yandex" {
  token     = ""
  cloud_id  = ""
  folder_id = ""
  zone      = "ru-central1-a"
}

