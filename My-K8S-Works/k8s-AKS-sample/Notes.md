> K8S

# CONTROL PLANE
- **API SERVER** --> All communication goes through API
- **SCHEDULER** --> takes your app, figures out available resources on available nodes and puts the pod on that node to run it.
- **CONTROLLER MANAGER** --> makes sure that there's a certain number of pods running at all times and it moves pods around if there's a node failure,...
- **ETCD** --> It's a data store for the cluster configuration, all of the configuration of the cluster is stored  in ETCD database, and if you were to lose the data you would esentially wiping out entire cluster.

# WORKER NODES
- These are essentially going to be responsible for running your application. control plane doesn't run any applications or doesn't run any containers. so, worker nodes are responsible for doing that.
- **CONTAINER RUNTIME** --> docker, containerd, ...
- **KUBELET** --> manages the containers and communicates with the container runtime to run those containers on those nodes.
- **KUBE-PROXY** --> handles all these service traffic between pods
- **POD** -->  Applications runs one or more containers within a pod.

# Benifits of AKS
- CONTROL PLANE is free
- API Management is not required
- Easy to upgrade the cluster
- create a private dev cluster
- Easily plug into other Azure Services like persistent storage like as your disk or as your file store. Take advantage of the load balancing capabilities 
- Networking --> CNI, DNS and Load Balancer built-in.

