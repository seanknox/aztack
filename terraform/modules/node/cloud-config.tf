data "template_file" "cloud-config" {
  template = "${file("${path.module}/cloud-config.yaml")}"
  count    = "${ var.node_count }"

  vars {
    HOSTNAME       = "node${ count.index + 1 }.${ var.internal-tld}"
    DNS_SERVICE_IP = "${ var.dns-service-ip }"
    POD_CIDR       = "${ var.pod-cidr }"
  }
}
