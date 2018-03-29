resource "azurerm_dns_zone" "internal" {
  name                = "${ var.internal-tld }"
  resource_group_name = "${ var.name }"
}

resource "azurerm_dns_a_record" "A-etcd" {
  name                = "etcd"
  zone_name           = "${azurerm_dns_zone.internal.name}"
  resource_group_name = "${ var.name }"
  ttl                 = 300
  records             = ["${ split(",", var.etcd-ips) }"]
}

resource "azurerm_dns_a_record" "A-etcds" {
  name                = "etcd${ count.index+1 }"
  zone_name           = "${azurerm_dns_zone.internal.name}"
  resource_group_name = "${ var.name }"
  ttl                 = 300

  records = [
    "${ element(split(",", var.etcd-ips), count.index) }",
  ]
}

resource "azurerm_dns_cname_record" "CNAME-master" {
  name                = "master"
  zone_name           = "${azurerm_dns_zone.internal.name}"
  resource_group_name = "${ var.name }"
  ttl                 = 300
  record              = "etcd.${ var.internal-tld }"
}

resource "azurerm_dns_srv_record" "etcd-client-tcp" {
  name                = "_etcd-client._tcp"
  zone_name           = "${azurerm_dns_zone.internal.name}"
  resource_group_name = "${ var.name }"
  ttl                 = 300

  record {
    priority = 0
    weight   = 0
    port     = 2379
    target   = "etcd1.${ var.internal-tld }"
  }

  record {
    priority = 0
    weight   = 0
    port     = 2379
    target   = "etcd2.${ var.internal-tld }"
  }

  record {
    priority = 0
    weight   = 0
    port     = 2379
    target   = "etcd3.${ var.internal-tld }"
  }

  tags {
    Environment = "Production"
  }
}

resource "azurerm_dns_srv_record" "etcd-server-tcp" {
  name                = "_etcd-server-ssl._tcp"
  zone_name           = "${azurerm_dns_zone.internal.name}"
  resource_group_name = "${ var.name }"
  ttl                 = 300

  record {
    priority = 0
    weight   = 0
    port     = 2380
    target   = "etcd1.${ var.internal-tld }"
  }

  record {
    priority = 0
    weight   = 0
    port     = 2380
    target   = "etcd2.${ var.internal-tld }"
  }

  record {
    priority = 0
    weight   = 0
    port     = 2380
    target   = "etcd3.${ var.internal-tld }"
  }

  tags {
    Environment = "Production"
  }
}

resource "null_resource" "dummy_dependency" {
  depends_on = [
    "azurerm_dns_srv_record.etcd-server-tcp",
    "azurerm_dns_a_record.A-etcd",
  ]
}
