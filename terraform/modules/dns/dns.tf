resource "null_resource" "enable_dns_ext" {
  # Enable private zone extension
  provisioner "local-exec" {
    on_failure = "continue"

    command = <<EOF
        az extension add --name dns
      EOF
  }
}

resource "null_resource" "dns_zone" {
  depends_on = ["null_resource.enable_dns_ext"]

  # Create private DNS zone that resolves automatically in the vnet
  provisioner "local-exec" {
    command = <<EOF
        az network dns zone create -g ${ var.resource_group_name } -n ${ var.internal-tld } --zone-type Private --registration-vnets ${ var.name }
      EOF
  }
}

resource "azurerm_dns_a_record" "A-etcd" {
  depends_on          = ["null_resource.dns_zone"]
  name                = "etcd"
  zone_name           = "${ var.internal-tld }"
  resource_group_name = "${ var.resource_group_name }"
  ttl                 = 300
  records             = ["${ split(",", var.etcd-ips) }"]
}

resource "azurerm_dns_a_record" "A-etcds" {
  depends_on = ["null_resource.dns_zone"]
  count      = "${ length( split(",", var.etcd-ips) ) }"

  name                = "etcd${ count.index+1 }"
  zone_name           = "${ var.internal-tld }"
  resource_group_name = "${ var.resource_group_name }"
  ttl                 = 300

  records = [
    "${ element(split(",", var.etcd-ips), count.index) }",
  ]
}

resource "azurerm_dns_cname_record" "CNAME-controller" {
  depends_on          = ["null_resource.dns_zone"]
  name                = "controller"
  zone_name           = "${ var.internal-tld }"
  resource_group_name = "${ var.resource_group_name }"
  ttl                 = 300
  record              = "etcd.${ var.internal-tld }"
}

resource "azurerm_dns_srv_record" "etcd-client-tcp" {
  depends_on          = ["null_resource.dns_zone"]
  name                = "_etcd-client-ssl._tcp"
  zone_name           = "${ var.internal-tld }"
  resource_group_name = "${ var.resource_group_name }"
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
  depends_on          = ["null_resource.dns_zone"]
  name                = "_etcd-server-ssl._tcp"
  zone_name           = "${ var.internal-tld }"
  resource_group_name = "${ var.resource_group_name }"
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
    "null_resource.dns_zone",
    "azurerm_dns_srv_record.etcd-server-tcp",
    "azurerm_dns_a_record.A-etcd",
  ]
}
