data "template_file" "cloud-config" {
  template = "${file("${path.module}/cloud-config.yaml")}"
  count    = "${ var.node_count }"

  vars {
    HOSTNAME              = "node${ count.index + 1 }.${ var.internal-tld}"
    DNS_SERVICE_IP        = "${ var.dns-service-ip }"
    POD_CIDR              = "${ var.pod-cidr }"
    LOCATION              = "${ lower(join("", split(" ", "${ var.location} "))) }"
    SUBSCRIPTION_ID       = "${ var.azure["subscription_id"]}"
    TENANT_ID             = "${ var.azure["tenant_id"]}"
    CLIENT_ID             = "${ var.azure["client_id"]}"
    CLIENT_SECRET         = "${ var.azure["client_secret"]}"
    NAME                  = "${ var.name }"
    AVAILABILITY_SET_NAME = "${ azurerm_availability_set.nodeavset.name }"
  }
}
