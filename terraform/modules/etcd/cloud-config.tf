data "template_file" "cloud-config" {
  template = "${file("${path.module}/cloud-config.yaml")}"
  count    = "${ length( split(",", var.etcd-ips) ) }"

  vars {
    ETCD_NAME     = "etcd${ count.index + 1 }"
    CLUSTER_TOKEN = "etcd-cluster-${ var.name }"
    INTERNAL_TLD  = "${ var.internal-tld }"
    FQDN          = "etcd${ count.index + 1 }.${ var.internal-tld }"
  }
}
