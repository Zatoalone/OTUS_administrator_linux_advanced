output "external_ip_address_ansible" {
  value = yandex_compute_instance.ansible.*.network_interface.0.nat_ip_address
}
output "external_ip_address_cluster_nodes" {
  value = yandex_compute_instance.cluster.*.network_interface.0.nat_ip_address
}
output "external_ip_address_storage" {
  value = yandex_compute_instance.storage.*.network_interface.0.nat_ip_address
}
output "internal_ip_address_cluster_nodes" {
  value = yandex_compute_instance.cluster.*.network_interface.0.ip_address
}

output "internal_ip_address_storage" {
  value = yandex_compute_instance.storage.*.network_interface.0.ip_address
}
