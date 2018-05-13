**Software**|**Version**
-----|-----
Ubuntu|17.10
cri-containerd|1.0.0.0
containerd|v1.0.0-6
runc|1.0.0-rc4+dev
etcd|v3.3.4
Kubernetes|v1.10.2
Azure-CNI|v1.0.4


**Control Plane**|**Status**|**Notes**
:-----:|:-----:|:-----:
Separate controllers from etcd|:white\_check\_mark: |controller and etcd running on different VMs
TLS between etcd and controllers|:white\_check\_mark: |
TLS between nodes and controllers|:white\_check\_mark: |
kube-controller-manager|:white\_check\_mark: |
kube-scheduler|:white\_check\_mark: |
kube-apiserver|:white\_check\_mark: |
kube-proxy|:white\_check\_mark: |
kubelet with NoSchedule|:white\_check\_mark: |
Admission Controllers|:white\_check\_mark: |Initializers, NodeRestriction, NamespaceLifecycle, LimitRanger, ServiceAccount, DefaultStorageClass, DefaultTolerationSeconds, MutatingAdmissionWebhook, ValidatingAdmissionWebhook, ResourceQuota
Anonymous Auth disabled|:white\_check\_mark: |
Node and RBAC auth mode enabled|:white\_check\_mark: |
Node Bootstrap token enabled|:white\_check\_mark: |
Distinct TLS certs for apiserver and etcd|TBD|apiserver and etcd currently sharing the same certs
etcd3 backend enabled|:white\_check\_mark: |


**Nodes**|**Status**|**Notes**
:-----:|:-----:|:-----:
TLS bootstrapping using tokens|:white\_check\_mark: |
kubelet certificates|:white\_check\_mark: |
kube-proxy|:white\_check\_mark: |
"kube exec" and "kube logs"|:white\_check\_mark: |


**Network**|**Status**|**Notes**
:-----:|:-----:|:-----:
Pod-to-pod communication|:white\_check\_mark: |
CNI enabled (azure-CNI)|:white\_check\_mark: |
Pod outbound internet|:x:|Pods cannot reach hosts on Internet
Pod to cluster service net|:x:|Pods cannot reach cluster service IPs (including apiserver)
All VMs on private network|:white\_check\_mark: |
Bastion host|:white\_check\_mark: |

**Cloud Provider / Azure**|**Status**|**Notes**
:-----:|:-----:|:-----:
PVCs working|:white\_check\_mark: |
Service of type LoadBalancer working|:x:|
Azure DNS for VM hostnames|:white\_check\_mark: |
Azure NSGs for apiserver|TBD|
Azure NSGs for etcd|TBD|
Azure NSGs for nodes|TBD|
Explicit MSI definition|TBD|
