# Creating a Deployment and exposing a Service in K8S

```
start https://shell.azure.com
```
```azurepowershell
git clone https://github.com/vijayraavi/super-k8s-Learning.git
cd super-k8s-Learning/My-K8S-Works/6-Expose-svc-K8S
code .
ls
```
Run below script
```bash
chmod +x ./k8s-two-node-cluster-deploy.sh
ls
./k8s-two-node-cluster-deploy.sh

# "ipAddress": "20.198.89.95",
# "ipAddress": "20.198.89.201",
```

```bash
# Set Variables from above generated IP address (Controller Node, Worker Node)
NODE0="<Controller Node IP>"
NODE1="<Worker Node IP>"

# NODE0="20.198.89.95"
# NODE1="20.198.89.201"
```
```bash
# SSH into controller Node
ssh azureuser@$NODE0
# password: 1StrongP@ssword!
```

```bash
# Execute below in controller node
ls
chmod +x k8s-initialize-cluster.sh
sudo !! # Execute Previous command with sudo
ls
./k8s-initialize-cluster.sh # Runs KUBEADM init, Initilizes CNI
# Copy kubeadm join command , to be used in worker nodes
    # kubeadm join 10.0.0.5:6443 --token 0vicme.jvac97p2iu2irsrb \
    # --discovery-token-ca-cert-hash sha256:caa0751046aecaf00ecdb0a9ede689b2545ae8bb11c488bba28d743e0966ecdd
exit
```
```bash
# SSH into worker node
ssh azureuser@$NODE1
# password: 1StrongP@ssword!
sudo kubeadm join # <paste kubeadm join command from previous step>
    #    sudo kubeadm join 10.0.0.5:6443 --token 0vicme.jvac97p2iu2irsrb \
    #     --discovery-token-ca-cert-hash sha256:caa0751046aecaf00ecdb0a9ede689b2545ae8bb11c488bba28d743e0966ecdd
exit
```
```bash
# Go to Controller Node -- NODE0
ssh azureuser@$NODE0
# password: 1StrongP@ssword!
kubectl get no
```
- Create two deployments
    - Backend
    - Frontend
> *Accomplish the ability for our backend to communicate with our front end using a **ClusterIP** service*

> Create **NodePort** Service that will allow outside visitors to access our frontend, which is very common way to do it.

# Create Backend (Mongodb)
```bash
# Go to Controller Node -- NODE0
wget https://raw.githubusercontent.com/vijayraavi/super-k8s-Learning/main/My-K8S-Works/6-Expose-svc-K8S/deploy-mongodb.yml

vim deploy-mongodb.yml

kubectl create -f deploy-mongodb.yml

kubectl get deploy

kubectl get po

# Now the backend is ready
```
### Expose the DB as a Service, so Frontend could reach it on port 27017(container port)
```bash
kubectl expose deploy mongodb --type ClusterIP --port 27017 --target-port 27017
# **ClusterIP** ensures that within the cluster & only inside the cluster the different pods and services can talk to each other.
# --port --> Port of the Service
# --target-port --> port that is exposed on cntainer
kubectl get svc

# Now we have mongodb deployment & mongodb service

```
# Create Frontend
```bash
# Go to Controller Node -- NODE0
wget https://raw.githubusercontent.com/vijayraavi/super-k8s-Learning/main/My-K8S-Works/6-Expose-svc-K8S/deploy-frontend.yml

ls
vim deploy-frontend.yml
        # replicas: 3 --> 3 pods total
        # image --> using docker vijayraavi/guestbook:v1 image here
kubectl create -f deploy-frontend.yml

kubectl get deploy

kubectl get po

# Now we have front end service
```
### Expose Frontend as Service - Create service using NodePort
```bash
# Go to Controller Node -- NODE0
kubectl expose deploy frontend --type NodePort --port 80

kubectl get svc

kubectl describe svc frontend
    # Note NodePort port ex:31213/TCP
exit
```
## Get public IP's of Nodes and browse front end on NodePort port
```bash
resourceGroupName="k8s-rg"

az vm list-ip-addresses -g $resourceGroupName|grep ipAddress
    # Node Worker Node IP / NODE1
```
> start http://WorkerNode-IP:31213/ #Check in Browser

# Sample History  for reference
```bash
vijay@Azure:~$ ls
clouddrive  super-k8s-Learning
vijay@Azure:~$ rm -rf super-k8s-Learning/
vijay@Azure:~$ ls
clouddrive
vijay@Azure:~$ git clone https://github.com/vijayraavi/super-k8s-Learning.git
Cloning into 'super-k8s-Learning'...
remote: Enumerating objects: 124, done.
remote: Counting objects: 100% (124/124), done.
remote: Compressing objects: 100% (85/85), done.
remote: Total 124 (delta 61), reused 92 (delta 35), pack-reused 0
Receiving objects: 100% (124/124), 70.22 KiB | 14.04 MiB/s, done.
Resolving deltas: 100% (61/61), done.
vijay@Azure:~$ cd super-k8s-Learning/My-K8S-Works/6-Expose-svc-K8S
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/6-Expose-svc-K8S$ code .
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/6-Expose-svc-K8S$ ls
6-Notes.md            deploy-frontend.yml  install-k8s-v1.20.sh       k8s-two-node-cluster-deploy.json
cloud-init-nginx.txt  deploy-mongodb.yml   k8s-initialize-cluster.sh  k8s-two-node-cluster-deploy.sh
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/6-Expose-svc-K8S$ ./k8s-two-node-cluster-deploy.sh
bash: ./k8s-two-node-cluster-deploy.sh: Permission denied
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/6-Expose-svc-K8S$ sudo k8s-two-node-cluster-deploy.sh
bash: sudo: command not found
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/6-Expose-svc-K8S$ sudo ./k8s-two-node-cluster-deploy.sh
bash: sudo: command not found
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/6-Expose-svc-K8S$ chmod +x k8s-two-node-cluster-deploy.sh
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/6-Expose-svc-K8S$ ls
6-Notes.md            deploy-frontend.yml  install-k8s-v1.20.sh       k8s-two-node-cluster-deploy.json
cloud-init-nginx.txt  deploy-mongodb.yml   k8s-initialize-cluster.sh  k8s-two-node-cluster-deploy.sh
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/6-Expose-svc-K8S$ ./k8s-two-node-cluster-deploy.sh
{
  "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg",
  "location": "centralindia",
  "managedBy": null,
  "name": "k8s-rg",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}
{
  "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Resources/deployments/k8s-twonode-deploy",
  "location": null,
  "name": "k8s-twonode-deploy",
  "properties": {
    "correlationId": "fa6f25e8-e56b-4c0b-8ff9-078aa090c286",
    "debugSetting": null,
    "dependencies": [
      {
        "dependsOn": [
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Network/networkSecurityGroups/nsg1-udpr2",
            "resourceGroup": "k8s-rg",
            "resourceName": "nsg1-udpr2",
            "resourceType": "Microsoft.Network/networkSecurityGroups"
          }
        ],
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Network/virtualNetworks/lab-VNet1",
        "resourceGroup": "k8s-rg",
        "resourceName": "lab-VNet1",
        "resourceType": "Microsoft.Network/virtualNetworks"
      },
      {
        "dependsOn": [
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Network/networkInterfaces/nic1-udpr20",
            "resourceGroup": "k8s-rg",
            "resourceName": "nic1-udpr20",
            "resourceType": "Microsoft.Network/networkInterfaces"
          }
        ],
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Compute/virtualMachines/k8s0",
        "resourceGroup": "k8s-rg",
        "resourceName": "k8s0",
        "resourceType": "Microsoft.Compute/virtualMachines"
      },
      {
        "dependsOn": [
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Network/networkInterfaces/nic1-udpr21",
            "resourceGroup": "k8s-rg",
            "resourceName": "nic1-udpr21",
            "resourceType": "Microsoft.Network/networkInterfaces"
          }
        ],
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Compute/virtualMachines/k8s1",
        "resourceGroup": "k8s-rg",
        "resourceName": "k8s1",
        "resourceType": "Microsoft.Compute/virtualMachines"
      },
      {
        "dependsOn": [
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Network/publicIpAddresses/pip-win-udpr20",
            "resourceGroup": "k8s-rg",
            "resourceName": "pip-win-udpr20",
            "resourceType": "Microsoft.Network/publicIpAddresses"
          },
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Network/virtualNetworks/lab-VNet1",
            "resourceGroup": "k8s-rg",
            "resourceName": "lab-VNet1",
            "resourceType": "Microsoft.Network/virtualNetworks"
          }
        ],
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Network/networkInterfaces/nic1-udpr20",
        "resourceGroup": "k8s-rg",
        "resourceName": "nic1-udpr20",
        "resourceType": "Microsoft.Network/networkInterfaces"
      },
      {
        "dependsOn": [
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Network/publicIpAddresses/pip-win-udpr21",
            "resourceGroup": "k8s-rg",
            "resourceName": "pip-win-udpr21",
            "resourceType": "Microsoft.Network/publicIpAddresses"
          },
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Network/virtualNetworks/lab-VNet1",
            "resourceGroup": "k8s-rg",
            "resourceName": "lab-VNet1",
            "resourceType": "Microsoft.Network/virtualNetworks"
          }
        ],
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Network/networkInterfaces/nic1-udpr21",
        "resourceGroup": "k8s-rg",
        "resourceName": "nic1-udpr21",
        "resourceType": "Microsoft.Network/networkInterfaces"
      },
      {
        "dependsOn": [
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Compute/virtualMachines/k8s0",
            "resourceGroup": "k8s-rg",
            "resourceName": "k8s0",
            "resourceType": "Microsoft.Compute/virtualMachines"
          }
        ],
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Compute/virtualMachines/k8s0/extensions/newuserscript",
        "resourceGroup": "k8s-rg",
        "resourceName": "k8s0/newuserscript",
        "resourceType": "Microsoft.Compute/virtualMachines/extensions"
      },
      {
        "dependsOn": [
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Compute/virtualMachines/k8s1",
            "resourceGroup": "k8s-rg",
            "resourceName": "k8s1",
            "resourceType": "Microsoft.Compute/virtualMachines"
          }
        ],
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Compute/virtualMachines/k8s1/extensions/newuserscript",
        "resourceGroup": "k8s-rg",
        "resourceName": "k8s1/newuserscript",
        "resourceType": "Microsoft.Compute/virtualMachines/extensions"
      }
    ],
    "duration": "PT2M35.5556975S",
    "error": null,
    "mode": "Incremental",
    "onErrorDeployment": null,
    "outputResources": [
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Compute/virtualMachines/k8s0",
        "resourceGroup": "k8s-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Compute/virtualMachines/k8s0/extensions/newuserscript",
        "resourceGroup": "k8s-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Compute/virtualMachines/k8s1",
        "resourceGroup": "k8s-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Compute/virtualMachines/k8s1/extensions/newuserscript",
        "resourceGroup": "k8s-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Network/networkInterfaces/nic1-udpr20",
        "resourceGroup": "k8s-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Network/networkInterfaces/nic1-udpr21",
        "resourceGroup": "k8s-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Network/networkSecurityGroups/nsg1-udpr2",
        "resourceGroup": "k8s-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Network/publicIpAddresses/pip-win-udpr20",
        "resourceGroup": "k8s-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Network/publicIpAddresses/pip-win-udpr21",
        "resourceGroup": "k8s-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/k8s-rg/providers/Microsoft.Network/virtualNetworks/lab-VNet1",
        "resourceGroup": "k8s-rg"
      }
    ],
    "outputs": {},
    "parameters": {},
    "parametersLink": null,
    "providers": [
      {
        "id": null,
        "namespace": "Microsoft.Network",
        "registrationPolicy": null,
        "registrationState": null,
        "resourceTypes": [
          {
            "aliases": null,
            "apiProfiles": null,
            "apiVersions": null,
            "capabilities": null,
            "defaultApiVersion": null,
            "locationMappings": null,
            "locations": [
              "centralindia"
            ],
            "properties": null,
            "resourceType": "networkSecurityGroups",
            "zoneMappings": null
          },
          {
            "aliases": null,
            "apiProfiles": null,
            "apiVersions": null,
            "capabilities": null,
            "defaultApiVersion": null,
            "locationMappings": null,
            "locations": [
              "centralindia"
            ],
            "properties": null,
            "resourceType": "virtualNetworks",
            "zoneMappings": null
          },
          {
            "aliases": null,
            "apiProfiles": null,
            "apiVersions": null,
            "capabilities": null,
            "defaultApiVersion": null,
            "locationMappings": null,
            "locations": [
              "centralindia"
            ],
            "properties": null,
            "resourceType": "publicIpAddresses",
            "zoneMappings": null
          },
          {
            "aliases": null,
            "apiProfiles": null,
            "apiVersions": null,
            "capabilities": null,
            "defaultApiVersion": null,
            "locationMappings": null,
            "locations": [
              "centralindia"
            ],
            "properties": null,
            "resourceType": "networkInterfaces",
            "zoneMappings": null
          }
        ]
      },
      {
        "id": null,
        "namespace": "Microsoft.Compute",
        "registrationPolicy": null,
        "registrationState": null,
        "resourceTypes": [
          {
            "aliases": null,
            "apiProfiles": null,
            "apiVersions": null,
            "capabilities": null,
            "defaultApiVersion": null,
            "locationMappings": null,
            "locations": [
              "centralindia"
            ],
            "properties": null,
            "resourceType": "virtualMachines",
            "zoneMappings": null
          },
          {
            "aliases": null,
            "apiProfiles": null,
            "apiVersions": null,
            "capabilities": null,
            "defaultApiVersion": null,
            "locationMappings": null,
            "locations": [
              "centralindia"
            ],
            "properties": null,
            "resourceType": "virtualMachines/extensions",
            "zoneMappings": null
          }
        ]
      }
    ],
    "provisioningState": "Succeeded",
    "templateHash": "12916895146302055666",
    "templateLink": null,
    "timestamp": "2021-06-02T19:14:02.976822+00:00",
    "validatedResources": null
  },
  "resourceGroup": "k8s-rg",
  "tags": null,
  "type": "Microsoft.Resources/deployments"
}
            "ipAddress": "20.198.89.95",
            "ipAddress": "20.198.89.201",
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/6-Expose-svc-K8S$ NODE0="20.198.89.95"
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/6-Expose-svc-K8S$ NODE1="20.198.89.201"
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/6-Expose-svc-K8S$ ssh azureuser@$NODE0
The authenticity of host '20.198.89.95 (20.198.89.95)' can't be established.
ECDSA key fingerprint is SHA256:ewtcOGk26YIt7f4kbOl4Z5LurVTyXG8EAIMmSvCCXrQ.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '20.198.89.95' (ECDSA) to the list of known hosts.
azureuser@20.198.89.95's password:
Welcome to Ubuntu 18.04.5 LTS (GNU/Linux 5.4.0-1047-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Wed Jun  2 19:17:44 UTC 2021

  System load:  0.02              Processes:              130
  Usage of /:   8.2% of 28.90GB   Users logged in:        0
  Memory usage: 8%                IP address for eth0:    10.0.0.5
  Swap usage:   0%                IP address for docker0: 172.17.0.1

24 updates can be applied immediately.
10 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

azureuser@k8s0:~$ ls
k8s-initialize-cluster.sh
azureuser@k8s0:~$ chmod +x k8s-initialize-cluster.sh
chmod: changing permissions of 'k8s-initialize-cluster.sh': Operation not permitted
azureuser@k8s0:~$ ls
k8s-initialize-cluster.sh
azureuser@k8s0:~$ chmod +x k8s-initialize-cluster.sh
chmod: changing permissions of 'k8s-initialize-cluster.sh': Operation not permitted
azureuser@k8s0:~$ sudo !!
sudo chmod +x k8s-initialize-cluster.sh
azureuser@k8s0:~$ ls
k8s-initialize-cluster.sh
azureuser@k8s0:~$ ./k8s-initialize-cluster.sh
I0602 19:19:11.470667   18069 version.go:251] remote version is much newer: v1.21.1; falling back to: stable-1.20
[init] Using Kubernetes version: v1.20.7
[preflight] Running pre-flight checks
        [WARNING SystemVerification]: this Docker version is not on the list of validated versions: 20.10.6. Latest validated version: 19.03
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [k8s0 kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 10.0.0.5]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [k8s0 localhost] and IPs [10.0.0.5 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [k8s0 localhost] and IPs [10.0.0.5 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Starting the kubelet
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
[apiclient] All control plane components are healthy after 8.501630 seconds
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config-1.20" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node k8s0 as control-plane by adding the labels "node-role.kubernetes.io/master=''" and "node-role.kubernetes.io/control-plane='' (deprecated)"
[mark-control-plane] Marking the node k8s0 as control-plane by adding the taints [node-role.kubernetes.io/master:NoSchedule]
[bootstrap-token] Using token: 0vicme.jvac97p2iu2irsrb
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 10.0.0.5:6443 --token 0vicme.jvac97p2iu2irsrb \
    --discovery-token-ca-cert-hash sha256:caa0751046aecaf00ecdb0a9ede689b2545ae8bb11c488bba28d743e0966ecdd
configmap/calico-config created
customresourcedefinition.apiextensions.k8s.io/bgpconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/bgppeers.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/blockaffinities.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/clusterinformations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/felixconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworksets.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/hostendpoints.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamblocks.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamconfigs.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamhandles.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ippools.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/kubecontrollersconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networksets.crd.projectcalico.org created
clusterrole.rbac.authorization.k8s.io/calico-kube-controllers created
clusterrolebinding.rbac.authorization.k8s.io/calico-kube-controllers created
clusterrole.rbac.authorization.k8s.io/calico-node created
clusterrolebinding.rbac.authorization.k8s.io/calico-node created
daemonset.apps/calico-node created
serviceaccount/calico-node created
deployment.apps/calico-kube-controllers created
serviceaccount/calico-kube-controllers created
poddisruptionbudget.policy/calico-kube-controllers created
azureuser@k8s0:~$ exit
logout
Connection to 20.198.89.95 closed.
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/6-Expose-svc-K8S$ ssh azureuser@$NODE1
The authenticity of host '20.198.89.201 (20.198.89.201)' can't be established.
ECDSA key fingerprint is SHA256:Qc0JeDHw9/uaL5tZtJSvckkMrFtJ1VOiiQi8fAoB6Fs.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '20.198.89.201' (ECDSA) to the list of known hosts.
azureuser@20.198.89.201's password:
Permission denied, please try again.
azureuser@20.198.89.201's password:
Welcome to Ubuntu 18.04.5 LTS (GNU/Linux 5.4.0-1047-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Wed Jun  2 19:22:31 UTC 2021

  System load:  0.09              Processes:              122
  Usage of /:   8.2% of 28.90GB   Users logged in:        0
  Memory usage: 8%                IP address for eth0:    10.0.0.4
  Swap usage:   0%                IP address for docker0: 172.17.0.1

22 updates can be applied immediately.
10 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

azureuser@k8s1:~$ sudo kubeadm join 10.0.0.5:6443 --token 0vicme.jvac97p2iu2irsrb \
>     --discovery-token-ca-cert-hash sha256:caa0751046aecaf00ecdb0a9ede689b2545ae8bb11c488bba28d743e0966ecdd
[preflight] Running pre-flight checks
        [WARNING SystemVerification]: this Docker version is not on the list of validated versions: 20.10.6. Latest validated version: 19.03
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.

azureuser@k8s1:~$ exit
logout
Connection to 20.198.89.201 closed.
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/6-Expose-svc-K8S$ ssh azureuser@$NODE0
azureuser@20.198.89.95's password:
Welcome to Ubuntu 18.04.5 LTS (GNU/Linux 5.4.0-1047-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Wed Jun  2 19:23:50 UTC 2021

  System load:  0.3                Users logged in:        0
  Usage of /:   12.8% of 28.90GB   IP address for eth0:    10.0.0.5
  Memory usage: 32%                IP address for docker0: 172.17.0.1
  Swap usage:   0%                 IP address for tunl0:   10.244.150.64
  Processes:    177


24 updates can be applied immediately.
10 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

New release '20.04.2 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Last login: Wed Jun  2 19:17:45 2021 from 20.193.233.131
azureuser@k8s0:~$ kubectl het no
Error: unknown command "het" for "kubectl"

Did you mean this?
        set
        get

Run 'kubectl --help' for usage.
azureuser@k8s0:~$ kubectl get no
NAME   STATUS   ROLES                  AGE     VERSION
k8s0   Ready    control-plane,master   3m58s   v1.20.2
k8s1   Ready    <none>                 59s     v1.20.2
azureuser@k8s0:~$ wget https://raw.githubusercontent.com/vijayraavi/super-k8s-Learning/main/My-K8S-Works/6-Expose-svc-K8S/deploy-mongodb.yml
--2021-06-02 19:24:34--  https://raw.githubusercontent.com/vijayraavi/super-k8s-Learning/main/My-K8S-Works/6-Expose-svc-K8S/deploy-mongodb.yml
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.110.133, 185.199.111.133, 185.199.108.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.110.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 716 [text/plain]
Saving to: ‘deploy-mongodb.yml’

deploy-mongodb.yml                        100%[=====================================================================================>]     716  --.-KB/s    in 0s

2021-06-02 19:24:35 (43.5 MB/s) - ‘deploy-mongodb.yml’ saved [716/716]

azureuser@k8s0:~$ vim deploy-mongodb.yml
azureuser@k8s0:~$ kubectl create -f deploy-mongodb.yml
deployment.apps/mongodb created
azureuser@k8s0:~$ kubectl get deploy
NAME      READY   UP-TO-DATE   AVAILABLE   AGE
mongodb   0/1     1            0           10s
azureuser@k8s0:~$ kubectl get deploy
NAME      READY   UP-TO-DATE   AVAILABLE   AGE
mongodb   0/1     1            0           14s
azureuser@k8s0:~$ kubectl get deploy
NAME      READY   UP-TO-DATE   AVAILABLE   AGE
mongodb   0/1     1            0           20s
azureuser@k8s0:~$ kubectl get deploy
NAME      READY   UP-TO-DATE   AVAILABLE   AGE
mongodb   0/1     1            0           22s
azureuser@k8s0:~$ kubectl get po
NAME                       READY   STATUS    RESTARTS   AGE
mongodb-7d99cb745d-94ltm   1/1     Running   0          33s
azureuser@k8s0:~$ kubectl get deploy
NAME      READY   UP-TO-DATE   AVAILABLE   AGE
mongodb   1/1     1            1           36s
azureuser@k8s0:~$ kubectl get po
NAME                       READY   STATUS    RESTARTS   AGE
mongodb-7d99cb745d-94ltm   1/1     Running   0          40s
azureuser@k8s0:~$ kubectl expose deploy mongodb --type ClusterIP --port 27017 --target-port 27017
service/mongodb exposed
azureuser@k8s0:~$ kubectl get svc
NAME         TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)     AGE
kubernetes   ClusterIP   10.96.0.1     <none>        443/TCP     6m40s
mongodb      ClusterIP   10.98.75.92   <none>        27017/TCP   24s
azureuser@k8s0:~$ wget https://raw.githubusercontent.com/vijayraavi/super-k8s-Learning/main/My-K8S-Works/6-Expose-svc-K8S/deploy-frontend.yml
--2021-06-02 19:27:14--  https://raw.githubusercontent.com/vijayraavi/super-k8s-Learning/main/My-K8S-Works/6-Expose-svc-K8S/deploy-frontend.yml
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.109.133, 185.199.108.133, 185.199.111.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.109.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 700 [text/plain]
Saving to: ‘deploy-frontend.yml’

deploy-frontend.yml                       100%[=====================================================================================>]     700  --.-KB/s    in 0s

2021-06-02 19:27:14 (38.1 MB/s) - ‘deploy-frontend.yml’ saved [700/700]

azureuser@k8s0:~$ ls
deploy-frontend.yml  deploy-mongodb.yml  k8s-initialize-cluster.sh
azureuser@k8s0:~$ vim deploy-frontend.yml
azureuser@k8s0:~$ kubectl create -f deploy-frontend.yml
deployment.apps/frontend created
azureuser@k8s0:~$ kubectl get deploy
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
frontend   0/3     3            0           6s
mongodb    1/1     1            1           2m40s
azureuser@k8s0:~$ kubectl get deploy
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
frontend   0/3     3            0           10s
mongodb    1/1     1            1           2m44s
azureuser@k8s0:~$ watch kubectl get deploy
azureuser@k8s0:~$ kubectl get deploy
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
frontend   3/3     3            3           62s
mongodb    1/1     1            1           3m36s
azureuser@k8s0:~$ kubectl get po
NAME                       READY   STATUS    RESTARTS   AGE
frontend-57c9676fb-dbsql   1/1     Running   0          67s
frontend-57c9676fb-dwq65   1/1     Running   0          67s
frontend-57c9676fb-tzwhv   1/1     Running   0          67s
mongodb-7d99cb745d-94ltm   1/1     Running   0          3m41s
azureuser@k8s0:~$ kubectl expose deploy frontend --type NodePort --port 80
service/frontend exposed
azureuser@k8s0:~$ kubectl get svc
NAME         TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
frontend     NodePort    10.103.4.95   <none>        80:31318/TCP   8s
kubernetes   ClusterIP   10.96.0.1     <none>        443/TCP        9m10s
mongodb      ClusterIP   10.98.75.92   <none>        27017/TCP      2m54s
azureuser@k8s0:~$ kubectl describe svc frontend
Name:                     frontend
Namespace:                default
Labels:                   app.kubernetes.io/component=frontend
                          app.kubernetes.io/name=guestbook
Annotations:              <none>
Selector:                 app.kubernetes.io/component=frontend,app.kubernetes.io/name=guestbook
Type:                     NodePort
IP Families:              <none>
IP:                       10.103.4.95
IPs:                      10.103.4.95
Port:                     <unset>  80/TCP
TargetPort:               80/TCP
NodePort:                 <unset>  31318/TCP
Endpoints:                10.244.166.194:80,10.244.166.195:80,10.244.166.196:80
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>
azureuser@k8s0:~$ az vm list-ip-addresses -g $resourceGroupName|grep ipAddress
az: command not found
azureuser@k8s0:~$ resourceGroupName="k8s-rg"
azureuser@k8s0:~$ az vm list-ip-addresses -g $resourceGroupName|grep ipAddress
az: command not found
azureuser@k8s0:~$ exit
logout
Connection to 20.198.89.95 closed.
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/6-Expose-svc-K8S$ resourceGroupName="k8s-rg"
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/6-Expose-svc-K8S$ az vm list-ip-addresses -g $resourceGroupName|grep ipAddress
            "ipAddress": "20.198.89.95",
            "ipAddress": "20.198.89.201",
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/6-Expose-svc-K8S$ NODE1
bash: NODE1: command not found
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/6-Expose-svc-K8S$ $NODE1
bash: 20.198.89.201: command not found
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/6-Expose-svc-K8S$ curl http://20.198.89.201:31318
<html ng-app="guestbook">
  <head>
    <meta content="text/html;charset=utf-8" http-equiv="Content-Type">
    <title>Guestbook</title>
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.2.12/angular.min.js"></script>
    <script src="controllers.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-bootstrap/0.13.0/ui-bootstrap-tpls.js"></script>
  </head>
  <body ng-controller="guestbookCtrl">
    <div style="width: 50%; margin-left: 20px">
      <h2>Guestbook</h2>
    <form>
    <fieldset>
    <input ng-model="msg" placeholder="Messages" class="form-control" type="text" name="input"><br>
    <button type="button" class="btn btn-primary" ng-click="controller.onguestbook()">Submit</button>
    </fieldset>
    </form>
    <div>
      <div ng-repeat="msg in messages track by $index">
        {{msg}}
      </div>
    </div>
    </div>
  </body>
</html>
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/6-Expose-svc-K8S$
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/6-Expose-svc-K8S$ cd ../../../
vijay@Azure:~$ ls
clouddrive  super-k8s-Learning
vijay@Azure:~$ rm -rf super-k8s-Learning/
vijay@Azure:~$ az group delete -g k8s-rg
Are you sure you want to perform this operation? (y/n): y
 \ Running ..

 | Running ..
 / Running ..
```

