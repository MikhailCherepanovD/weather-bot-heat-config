# Follow instructions:
# https://yandex.cloud/ru/docs/tutorials/infrastructure-management/terraform-quickstart

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

data "external" "ya_auth" {
  program = [
    "bash", "yc_vars.sh",
  ]
  query = {
    # You can pass something to STDIN of your program here, 
    # but as per current version, the input will be given as JSON (map of string)
  }
}

provider "yandex" {
  token = data.external.ya_auth.result.token
  cloud_id =  data.external.ya_auth.result.cloud_id
  folder_id =  data.external.ya_auth.result.folder_id
  zone = "ru-central1-a"
}


resource "yandex_compute_disk" "boot-disk-1" {
  name     = "boot-disk-1"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "20"
  image_id = "fd833v6c5tb0udvk4jo6" # ubuntu 22.04 LTS v20240325
}

resource "yandex_compute_instance" "vm-1" {
  name = "cherepanov-terraform"

  resources {
    cores  = 2 # 2, 4, 6, 8, 10, 12, 14, 16, 20, 24, 28, 32 allowed
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-1.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_security_group" "group1" {
  name        = "mikhail-security-group"
  network_id  = yandex_vpc_network.network-1.id
}

resource "yandex_vpc_security_group_rule" "ssh-rule" {
  security_group_binding = yandex_vpc_security_group.group1.id
  direction              = "ingress"
  description            = "mhq ssh"
  v4_cidr_blocks         = ["0.0.0.0/32"]
  port                   = 22
  protocol               = "TCP"
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

output "servers" {
  value = {
    serverip = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
  }
}
