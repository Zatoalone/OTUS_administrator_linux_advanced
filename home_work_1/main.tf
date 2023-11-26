resource "yandex_compute_instance" "default" {
  name        = "web-nginx"
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8m3j9ott9u69hks0gg" # Ubuntu, 22.04 LTS
    }

  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.custom_subnet.id
    security_group_ids = [yandex_vpc_security_group.webserver_vpc_sg.id]
    nat                = true
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ubuntu\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=(ALL) NOPASSWD:ALL'\n    ssh-authorized-keys:\n      - ${var.public_key}"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt install -y curl"
    ]
    connection {
      host        = self.network_interface.0.nat_ip_address
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook -u ubuntu -i '${self.network_interface.0.nat_ip_address},' --private-key ${var.private_key_path} nginx-playbook.yml"
  }
}



resource "yandex_vpc_network" "webservers_vpc_network" {
  name = "WebServers_vpc"
  description = "VPC for WebServers "

}
resource "yandex_vpc_subnet" "custom_subnet" {
  name = "WebServers_subnet"
  description = "Subnet for WebServers"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.webservers_vpc_network.id
  v4_cidr_blocks = ["10.2.0.0/24"]
}



resource "yandex_vpc_security_group" "webserver_vpc_sg" {
  name        = "WebServers_security_group"
  description = "Security group for WebServers"
  network_id  = yandex_vpc_network.webservers_vpc_network.id

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  #ingress {
  #  protocol       = "TCP"
  #  v4_cidr_blocks = ["0.0.0.0/0"]
  #  port           = 443
  #}

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  egress {
    protocol       = "ANY"
    description    = "Outcoming traf"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = -1
  }
}
