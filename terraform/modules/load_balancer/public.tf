resource "azurerm_public_ip" "lbpip" {
  name                         = "lbpip"
  location                     = "${ var.location }"
  resource_group_name          = "${ var.name }"
  public_ip_address_allocation = "dynamic"
  domain_name_label            = "${ var.name }"

  tags {
    environment = "test"
  }
}

resource "azurerm_lb" "extlb" {
  name                = "${ var.name }-public"
  location            = "${ var.location }"
  resource_group_name = "${ var.name }"

  frontend_ip_configuration {
    name                 = "LoadBalancerFrontEndPublic"
    public_ip_address_id = "${azurerm_public_ip.lbpip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "public_backend_pool" {
  resource_group_name = "${ var.name }"
  loadbalancer_id     = "${azurerm_lb.extlb.id}"
  name                = "BackendPoolPublic"
}

resource "azurerm_lb_rule" "apiserver_public" {
  resource_group_name            = "${ var.name }"
  loadbalancer_id                = "${azurerm_lb.extlb.id}"
  name                           = "kube-api-public"
  protocol                       = "tcp"
  frontend_port                  = 8443
  backend_port                   = 6443
  frontend_ip_configuration_name = "LoadBalancerFrontEndPublic"
  enable_floating_ip             = false
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.public_backend_pool.id}"
  idle_timeout_in_minutes        = 4
  probe_id                       = "${azurerm_lb_probe.lb_probe_public.id}"
  depends_on                     = ["azurerm_lb_probe.lb_probe_public"]
}

resource "azurerm_lb_probe" "lb_probe_public" {
  resource_group_name = "${ var.name }"
  loadbalancer_id     = "${azurerm_lb.extlb.id}"
  name                = "kube-api-publicProbe"
  protocol            = "tcp"
  port                = 6443
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "null_resource" "dummy_dependency" {
  depends_on = [
    "azurerm_lb.extlb",
    "azurerm_lb.intlb",
  ]
}
