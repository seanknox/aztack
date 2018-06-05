resource "azurerm_lb" "intlb" {
  name                = "${ var.name }-private"
  location            = "${ var.location }"
  resource_group_name = "${ var.resource_group_name }"

  frontend_ip_configuration {
    name                          = "LoadBalancerFrontEndPrivate"
    private_ip_address_allocation = "static"
    private_ip_address            = "${ var.kube-api-internal-ip }"
    subnet_id                     = "${ var.private-subnet-id }"
  }
}

resource "azurerm_lb_backend_address_pool" "private_backend_pool" {
  resource_group_name = "${ var.resource_group_name }"
  loadbalancer_id     = "${azurerm_lb.intlb.id}"
  name                = "BackendPoolPrivate"
}

resource "azurerm_lb_rule" "apiserver-private" {
  resource_group_name            = "${ var.resource_group_name }"
  loadbalancer_id                = "${azurerm_lb.intlb.id}"
  name                           = "kube-api-private"
  protocol                       = "tcp"
  frontend_port                  = 6443
  backend_port                   = 6443
  frontend_ip_configuration_name = "LoadBalancerFrontEndPrivate"
  enable_floating_ip             = false
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.private_backend_pool.id}"
  idle_timeout_in_minutes        = 4
  probe_id                       = "${azurerm_lb_probe.lb_probe_private.id}"
  depends_on                     = ["azurerm_lb_probe.lb_probe_private"]
}

resource "azurerm_lb_probe" "lb_probe_private" {
  resource_group_name = "${ var.resource_group_name }"
  loadbalancer_id     = "${azurerm_lb.intlb.id}"
  name                = "kube-api-privateProbe"
  protocol            = "tcp"
  port                = 6443
  interval_in_seconds = 5
  number_of_probes    = 2
}
