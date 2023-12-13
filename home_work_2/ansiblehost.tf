resource "yandex_compute_instance" "ansible" {

  name     = "ansible"
  hostname = "ansible"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet01.id
    nat       = true
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ${var.ssh_user}\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=(ALL) NOPASSWD:ALL'\n    ssh-authorized-keys:\n      - ${tls_private_key.ssh.public_key_openssh}"
  }

  connection {
    type        = "ssh"
    user        = "cl-user"
    private_key = tls_private_key.ssh.private_key_pem
    host        = self.network_interface.0.nat_ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'host is up'",
      "sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm",
      "sudo dnf update -y",
      "sudo dnf install -y ansible"
    ]
  }

  provisioner "file" {
    source      = "./ansible"
    destination = "/home/${var.ssh_user}"

  }

  provisioner "file" {
    source      = "./ssh/id_rsa"
    destination = "/home/cl-user/.ssh/id_rsa"

  }

  provisioner "file" {
    source      = "./ssh/id_rsa.pub"
    destination = "/home/cl-user/.ssh/id_rsa.pub"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/cl-user/.ssh/id_rsa"
    ]

  }

  provisioner "file" {
    source      = "./ansible/ansible.cfg"
    destination = "/home/cl-user/ansible.cfg"

  }

  provisioner "remote-exec" {
    inline = [
  "ansible-playbook -u cl-user -i /home/cl-user/ansible/hosts /home/cl-user/ansible/playbooks/main.yml",
    ]
  }

  depends_on = [
    yandex_compute_instance.cluster,
    yandex_compute_instance.storage,
  ]
}
