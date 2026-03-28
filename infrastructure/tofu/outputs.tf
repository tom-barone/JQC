output "JQC_SERVER_IP_ADDRESS" {
  value     = one(linode_instance.server.ipv4)
  sensitive = true
}

output "JQC_HOSTNAME" {
  value     = "${local.domain_prefix}${local.domain}"
  sensitive = true
}

output "JQC_HOSTNAME_MONITORING" {
  value     = "${local.domain_prefix}monitoring.${local.domain}"
  sensitive = true
}


