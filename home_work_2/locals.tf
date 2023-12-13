provider "tls" {}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "private_ssh" {
  filename        = "./ssh/id_rsa"
  content         = tls_private_key.ssh.private_key_pem
  file_permission = "0600"
}

resource "local_file" "public_ssh" {
  filename        = "./ssh/id_rsa.pub"
  content         = tls_private_key.ssh.public_key_openssh
  file_permission = "0600"
}

resource "local_file" "hosts" {
  filename = "./ansible/hosts"
  content = templatefile("hosts.tpl",
    {
      cluster_hosts   = yandex_compute_instance.cluster.*.network_interface.0.ip_address
      storage_hosts = yandex_compute_instance.storage.*.network_interface.0.ip_address
    }
  )
  depends_on = [
    yandex_compute_instance.cluster,
    yandex_compute_instance.storage,
  ]
}
