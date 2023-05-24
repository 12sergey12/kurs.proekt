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
  token     = "y0_AgAAAABQoySwAATuwQAAAADh7F8nSIVDfa-GRkim2g4tsW6eqhGWnio"
  cloud_id  = "b1gupe0u1qqfpl0fuip5"
  folder_id = "b1gi8mor51pqsp67s6t9"
  zone      = "ru-central1-a"
}

