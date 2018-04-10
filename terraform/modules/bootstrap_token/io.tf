variable "depends-id" {}

output "admin_token" {
  value = "${ data.external.admin_token.result.admin_token }"
}

output "node_token" {
  value = "${ data.external.node_token.result.node_token }"
}

output "depends-id" {
  value = "${null_resource.dummy_dependency.id}"
}
