data "template_file" "cloud-config" {
  template = "${file("${path.module}/cloud-config.yaml")}"
  count    = "${ length( split(",", var.etcd-ips) ) }"

  vars {
    ETCD_NAME        = "etcd${ count.index + 1 }"
    CLUSTER_TOKEN    = "etcd-cluster-${ var.name }"
    INTERNAL_TLD     = "${ var.internal-tld }"
    FQDN             = "etcd${ count.index + 1 }.${ var.internal-tld }"
    INTERNAL_IP      = "${azurerm_network_interface.controller.*.private_ip_address[count.index]}"
    DNS_SERVICE_IP   = "${ var.dns-service-ip }"
    ETCD_IP1         = "${azurerm_network_interface.controller.*.private_ip_address[0]}"
    ETCD_IP2         = "${azurerm_network_interface.controller.*.private_ip_address[1]}"
    ETCD_IP3         = "${azurerm_network_interface.controller.*.private_ip_address[2]}"
    POD_CIDR         = "${ var.pod-cidr }"
    LOCATION         = "${ var.location }"
    SERVICE_IP_RANGE = "${ var.service-cidr }"
    SUBSCRIPTION_ID  = "${ var.azure["subscription_id"]}"
    TENANT_ID        = "${ var.azure["tenant_id"]}"
    CLIENT_ID        = "${ var.azure["client_id"]}"
    CLIENT_SECRET    = "${ var.azure["client_secret"]}"
    NAME             = "${ var.name }"
  }
}
