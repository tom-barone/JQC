output "SERVER_IP_ADDRESS" {
  value = one(linode_instance.server.ipv4)
  sensitive = true
}
