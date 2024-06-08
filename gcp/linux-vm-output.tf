#####################################
## Virtual Machine Module - Output ##
#####################################
output "vm_linux_server_instance_name" {
  value = google_compute_instance.linux-server.name
}

output "vm_linux_server_instance_public_ip" {
  #value = data.google_compute_instance.gcp-compute-instance.network_interface[0].access_config[0].nat_ip
  value = "${join(" ", google_compute_instance.linux-server.*.network_interface.0.access_config.0.nat_ip)}"
  description = "The public IP address of the newly created instance"
}
