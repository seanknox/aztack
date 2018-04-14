addons:
	kubectl get pods --namespace=kube-system

csr:
	kubectl get csr

dns:
	kubectl exec busybox -- nslookup kubernetes

nodes:
	kubectl get nodes

pods:
	@kubectl get pods --all-namespaces -o wide

.PHONY: addons dns nodes pods
