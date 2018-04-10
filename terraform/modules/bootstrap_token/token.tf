data "external" "admin_token" {
  program = ["bash", "${path.module}/../../scripts/generate_bootstrap_token"]
}

data "external" "node_token" {
  program = ["bash", "${path.module}/../../scripts/generate_bootstrap_token"]
}

resource "null_resource" "dummy_dependency" {
  depends_on = [
    "data.external.admin_token",
    "data.external.node_token",
  ]
}
