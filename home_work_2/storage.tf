resource "yandex_compute_instance" "storage" {

  name     = "storage"
  hostname = "storage"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  secondary_disk {
    disk_id     = yandex_compute_disk.storage.id
    device_name = "storage_disk"
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet01.id
    nat       = true
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ${var.ssh_user}\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=(ALL) NOPASSWD:ALL'\n    ssh-authorized-keys:\n      - ${tls_private_key.ssh.public_key_openssh}"
  }

}

resource "yandex_compute_disk" "storage" {
  name = "iscsi-disk"
  size = 2
}
