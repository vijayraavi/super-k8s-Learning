# Working with persistent data in k8s cluster
> Deploying persistent volume that's going to contain our content for our ghost blog.

```bash
start https://shell.azure.com
```
```bash
git clone https://github.com/vijayraavi/super-k8s-Learning.git
cd super-k8s-Learning/My-K8S-Works/7-Persistent-Data-k8s-cluster
code .
ls
```
```bash
chmod +x k8s-two-node-disk-attached.sh
# Run below file
./k8s-two-node-disk-attached.sh

# Returns IP addresses of two Nodes
    # "ipAddress": "52.172.248.199",
    # "ipAddress": "52.172.251.175",
# Set Variables
NODE0="" #Controller Node IP
NODE1="" #Worker Node IP

    # NODE0="52.172.248.199" #Controller Node IP
    # NODE1="52.172.251.175" #Worker Node IP
```
```bash
# SSH into Controller Node | NODE0
ssh azureuser@$NODE0
# password: 1StrongP@ssword!

ls
# Run below - Install Cluster & CNI
sudo bash k8s-initialize-cluster.sh
# Copy Kuneadm join command
    # kubeadm join 10.0.0.5:6443 --token phjpch.treepmqaxqpiivpj \
    # --discovery-token-ca-cert-hash sha256:114055903215ad4f1ba34e918e1c0601f66d15be98399cbeb8a2f9c7519d50ca
exit
```
```bash
# SSH into Worker Node | NODE1
ssh azureuser@$NODE1
# password: 1StrongP@ssword!
# Execute kubeadm join command - copied earlier
sudo #paste kubeadm join command
    # sudo kubeadm join 10.0.0.5:6443 --token phjpch.treepmqaxqpiivpj \
    #     --discovery-token-ca-cert-hash sha256:114055903215ad4f1ba34e918e1c0601f66d15be98399cbeb8a2f9c7519d50ca

exit
```
```bash
# SSH into Controller Node | NODE0
ssh azureuser@$NODE0
# password: 1StrongP@ssword!
kubectl get no

# create additional namespace, to seperate our k8s resources from other resources in the default, kubesystem ns. just as a logical seperation & allow us to work under one namespace.
kubectl get ns

```
### create  ghost namespace
```bash
kubectl create ns ghost

kubectl get ns
```
> create resources inside ghost ns

## create Persistent Volume(PV)
```bash
vi pv.yml
# paste below content
kind: PersistentVolume
apiVersion: v1
metadata:
  name: ghost-vol
  labels:
      type: local  # uses local disk from node
spec:
  capacity:
    storage: 50Gi
  accessModes:
    - ReadWriteOnce # only one node can read write at once
  hostPath:
    path: "/ghost"

:wq! # save and quit
```
**This is persistent volume (pv), which is non namespace resource, so we don't have to include a namespace**

```bash
kubectl get pv
# create persistent volume
kubectl create -f pv.yml

kubectl get pv
```
## Create a Persitent Volume Claim(PVC)
```bash
vi pvc.yml
# paste below content
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ghost-pv-claim
  namespace: ghost            # namespaced resource
  labels:
    app: ghost
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 50Gi


:wq!
```
```bash
kubectl get pvc

kubectl create -f pvc.yml

kubectl get pvc

kubectl get pvc -n ghost

```
## Create a deployment which is going to use pvc storage for pods.
```bash
vi deploy.yml
# Paste below content
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ghost
  namespace: ghost
  labels:
    app: ghost
    release: 4.4.0
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ghost
      release: 4.4.0
  template:
    metadata:
      labels:
        app: ghost
        release: 4.4.0
    spec:  # container spec
      volumes:
        - name: ghost-content
          persistentVolumeClaim:
            claimName: ghost-pv-claim
      containers:
        - name: ghost
          image: ghost:4.4.0
          volumeMounts:
            - name: ghost-content
              mountPath: /var/lib/ghost/content  # ghost is pv
          resources:
            limits:
              cpu: "1"
              memory: 256Mi
            requests:
              cpu: 100m
              memory: 64Mi
          ports:
            - name: http
              containerPort: 2368 # container port
              protocol: TCP
      restartPolicy: Always

:wq! 
```
```bash
kubectl get deploy -n ghost

kubectl create -f deploy.yml
kubectl get deploy
kubectl get deploy -n ghost
kubectl get po -n ghost
```
## Create a Service -- that allows to access our app running in our container | NodePort
```bash
vi svc.yml
# Paste below content
apiVersion: v1
kind: Service
metadata:
  name: ghost
  namespace: ghost
spec:
  type: NodePort
  selector:
    app: ghost  # all pods with label app-ghost
  ports:
  - protocol: TCP
    port: 80  # service port
    targetPort: 2368 # container port

:wq!
```
```bash
kubectl create -f svc.yml
kubectl get svc -n ghost
    # azureuser@k8s0:~$ kubectl get svc -n ghost
    # NAME    TYPE       CLUSTER-IP   EXTERNAL-IP   PORT(S)        AGE
    # ghost   NodePort   10.97.6.10   <none>        80:30709/TCP   6s
#Note NodePort svc port Ex: 30709
exit 
# exit from Controller Node NODE0
```
```bash
echo $NODE1
    # 52.172.251.175
# note public IP
# In browser use : http://$NODE1-IP:NodePort-SVC-Port
    # Ex: http://52.172.251.175:30709
# Now you'll see ghost blog up and running.
# To  Modify Blog in some way (content that is mounted to pods)
# Go to Controller Node terminal
ssh azureuser@$NODE0
# password: 1StrongP@ssword!

kubectl get po -n ghost
    # azureuser@k8s0:~$ kubectl get po -n ghost
    # NAME                     READY   STATUS    RESTARTS   AGE
    # ghost-794dbb97d6-ntqjg   1/1     Running   0          6m4s
# Open Interactive terminal of a running POD
kubectl exec -it <podname> -c ghost -n ghost -- /bin/bash
# ex: kubectl exec -it ghost-794dbb97d6-ntqjg -c ghost -n ghost -- /bin/bash
# -it --> Opens interactive terminal
# -c --> specify if you have multiple containers inside a pod

# Inside running pod
pwd
ls
cd content 
pwd # /var/lib/ghost/content  --> PVC
ls
cd themes
ls
cd casper
ls
#Modify any file contents, It will be persistent as we are using PVC

```
# SAMPLE HISTORY
```bash
Requesting a Cloud Shell.Succeeded.
Connecting terminal...

Welcome to Azure Cloud Shell

Type "az" to use Azure CLI
Type "help" to learn about Cloud Shell

vijay@Azure:~$ git clone https://github.com/vijayraavi/super-k8s-Learning.git
fatal: destination path 'super-k8s-Learning' already exists and is not an empty directory.
vijay@Azure:~$ ls
clouddrive  super-k8s-Learning
vijay@Azure:~$ rm -rf super-k8s-Learning/
vijay@Azure:~$ ls
clouddrive
vijay@Azure:~$ git clone https://github.com/vijayraavi/super-k8s-Learning.git
Cloning into 'super-k8s-Learning'...
remote: Enumerating objects: 151, done.
remote: Counting objects: 100% (151/151), done.
remote: Compressing objects: 100% (111/111), done.
remote: Total 151 (delta 79), reused 102 (delta 36), pack-reused 0
Receiving objects: 100% (151/151), 79.76 KiB | 15.95 MiB/s, done.
Resolving deltas: 100% (79/79), done.
vijay@Azure:~$ cd super-k8s-Learning/My-K8S-Works/7-Persistent-Data-k8s-cluster
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/7-Persistent-Data-k8s-cluster$ code .
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/7-Persistent-Data-k8s-cluster$ ls
7-Notes.md  install-k8s-v1.20.sh       k8s-two-node-cluster-attached-disk.json  pvc.yml  svc.yml
deploy.yml  k8s-initialize-cluster.sh  k8s-two-node-disk-attached.sh            pv.yml
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/7-Persistent-Data-k8s-cluster$ chmod +x k8s-two-node-disk-attached.sh
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/7-Persistent-Data-k8s-cluster$ ls
7-Notes.md  install-k8s-v1.20.sh       k8s-two-node-cluster-attached-disk.json  pvc.yml  svc.yml
deploy.yml  k8s-initialize-cluster.sh  k8s-two-node-disk-attached.sh            pv.yml
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/7-Persistent-Data-k8s-cluster$ ./k8s-two-node-disk-attached.sh
{
  "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg",
  "location": "centralindia",
  "managedBy": null,
  "name": "pvck8s-rg",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}
 | Running ..
{
  "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Resources/deployments/pvck8s-deploy",
  "location": null,
  "name": "pvck8s-deploy",
  "properties": {
    "correlationId": "ae2e8276-0cca-42a6-a881-c9aac329a904",
    "debugSetting": null,
    "dependencies": [
      {
        "dependsOn": [
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Network/networkSecurityGroups/microk8s-nsg",
            "resourceGroup": "pvck8s-rg",
            "resourceName": "microk8s-nsg",
            "resourceType": "Microsoft.Network/networkSecurityGroups"
          }
        ],
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Network/virtualNetworks/vnet-ktcqutuoqykkw",
        "resourceGroup": "pvck8s-rg",
        "resourceName": "vnet-ktcqutuoqykkw",
        "resourceType": "Microsoft.Network/virtualNetworks"
      },
      {
        "dependsOn": [
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Network/networkSecurityGroups/microk8s-nsg",
            "resourceGroup": "pvck8s-rg",
            "resourceName": "microk8s-nsg",
            "resourceType": "Microsoft.Network/networkSecurityGroups"
          },
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Network/virtualNetworks/vnet-ktcqutuoqykkw",
            "resourceGroup": "pvck8s-rg",
            "resourceName": "vnet-ktcqutuoqykkw",
            "resourceType": "Microsoft.Network/virtualNetworks"
          },
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Network/publicIpAddresses/node1-pubip1",
            "resourceGroup": "pvck8s-rg",
            "resourceName": "node1-pubip1",
            "resourceType": "Microsoft.Network/publicIpAddresses"
          }
        ],
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Network/networkInterfaces/node1-nic1",
        "resourceGroup": "pvck8s-rg",
        "resourceName": "node1-nic1",
        "resourceType": "Microsoft.Network/networkInterfaces"
      },
      {
        "dependsOn": [
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Network/networkSecurityGroups/microk8s-nsg",
            "resourceGroup": "pvck8s-rg",
            "resourceName": "microk8s-nsg",
            "resourceType": "Microsoft.Network/networkSecurityGroups"
          },
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Network/virtualNetworks/vnet-ktcqutuoqykkw",
            "resourceGroup": "pvck8s-rg",
            "resourceName": "vnet-ktcqutuoqykkw",
            "resourceType": "Microsoft.Network/virtualNetworks"
          },
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Network/publicIpAddresses/node2-pubip2",
            "resourceGroup": "pvck8s-rg",
            "resourceName": "node2-pubip2",
            "resourceType": "Microsoft.Network/publicIpAddresses"
          }
        ],
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Network/networkInterfaces/node2-nic1",
        "resourceGroup": "pvck8s-rg",
        "resourceName": "node2-nic1",
        "resourceType": "Microsoft.Network/networkInterfaces"
      },
      {
        "dependsOn": [
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Network/networkInterfaces/node1-nic1",
            "resourceGroup": "pvck8s-rg",
            "resourceName": "node1-nic1",
            "resourceType": "Microsoft.Network/networkInterfaces"
          }
        ],
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Compute/virtualMachines/k8s0",
        "resourceGroup": "pvck8s-rg",
        "resourceName": "k8s0",
        "resourceType": "Microsoft.Compute/virtualMachines"
      },
      {
        "dependsOn": [
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Compute/virtualMachines/k8s0",
            "resourceGroup": "pvck8s-rg",
            "resourceName": "k8s0",
            "resourceType": "Microsoft.Compute/virtualMachines"
          }
        ],
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Compute/virtualMachines/k8s0/extensions/newuserscript",
        "resourceGroup": "pvck8s-rg",
        "resourceName": "k8s0/newuserscript",
        "resourceType": "Microsoft.Compute/virtualMachines/extensions"
      },
      {
        "dependsOn": [
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Network/networkInterfaces/node2-nic1",
            "resourceGroup": "pvck8s-rg",
            "resourceName": "node2-nic1",
            "resourceType": "Microsoft.Network/networkInterfaces"
          }
        ],
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Compute/virtualMachines/k8s1",
        "resourceGroup": "pvck8s-rg",
        "resourceName": "k8s1",
        "resourceType": "Microsoft.Compute/virtualMachines"
      },
      {
        "dependsOn": [
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Compute/virtualMachines/k8s1",
            "resourceGroup": "pvck8s-rg",
            "resourceName": "k8s1",
            "resourceType": "Microsoft.Compute/virtualMachines"
          }
        ],
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Compute/virtualMachines/k8s1/extensions/newuserscript",
        "resourceGroup": "pvck8s-rg",
        "resourceName": "k8s1/newuserscript",
        "resourceType": "Microsoft.Compute/virtualMachines/extensions"
      }
    ],
    "duration": "PT2M43.3576966S",
    "error": null,
    "mode": "Incremental",
    "onErrorDeployment": null,
    "outputResources": [
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Compute/virtualMachines/k8s0",
        "resourceGroup": "pvck8s-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Compute/virtualMachines/k8s0/extensions/newuserscript",
        "resourceGroup": "pvck8s-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Compute/virtualMachines/k8s1",
        "resourceGroup": "pvck8s-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Compute/virtualMachines/k8s1/extensions/newuserscript",
        "resourceGroup": "pvck8s-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Network/networkInterfaces/node1-nic1",
        "resourceGroup": "pvck8s-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Network/networkInterfaces/node2-nic1",
        "resourceGroup": "pvck8s-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Network/networkSecurityGroups/microk8s-nsg",
        "resourceGroup": "pvck8s-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Network/publicIpAddresses/node1-pubip1",
        "resourceGroup": "pvck8s-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Network/publicIpAddresses/node2-pubip2",
        "resourceGroup": "pvck8s-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/pvck8s-rg/providers/Microsoft.Network/virtualNetworks/vnet-ktcqutuoqykkw",
        "resourceGroup": "pvck8s-rg"
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
            "resourceType": "networkInterfaces",
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
    "templateHash": "7758097796573281377",
    "templateLink": null,
    "timestamp": "2021-06-07T21:07:33.765516+00:00",
    "validatedResources": null
  },
  "resourceGroup": "pvck8s-rg",
  "tags": null,
  "type": "Microsoft.Resources/deployments"
}
            "ipAddress": "52.172.248.199",
            "ipAddress": "52.172.251.175",
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/7-Persistent-Data-k8s-cluster$
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/7-Persistent-Data-k8s-cluster$ NODE0="52.172.248.199" #Controller Node IP
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/7-Persistent-Data-k8s-cluster$ NODE1="52.172.251.175" #Worker Node IP
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/7-Persistent-Data-k8s-cluster$ ssh azureuser@$NODE0
The authenticity of host '52.172.248.199 (52.172.248.199)' can't be established.
ECDSA key fingerprint is SHA256:0uAm8dQyXKDvQJczWR/ZbRrdcwO4NdIMdYh+l4oTbVg.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '52.172.248.199' (ECDSA) to the list of known hosts.
azureuser@52.172.248.199's password:
Welcome to Ubuntu 18.04.5 LTS (GNU/Linux 5.4.0-1047-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Mon Jun  7 21:10:35 UTC 2021

  System load:  0.04              Processes:              128
  Usage of /:   8.2% of 28.90GB   Users logged in:        0
  Memory usage: 4%                IP address for eth0:    10.0.0.5
  Swap usage:   0%                IP address for docker0: 172.17.0.1

43 updates can be applied immediately.
26 of these updates are standard security updates.
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
azureuser@k8s0:~$ sudo bash k8s-initialize-cluster.sh
I0607 21:10:53.748274   17683 version.go:251] remote version is much newer: v1.21.1; falling back to: stable-1.20
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
[apiclient] All control plane components are healthy after 11.002476 seconds
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config-1.20" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node k8s0 as control-plane by adding the labels "node-role.kubernetes.io/master=''" and "node-role.kubernetes.io/control-plane='' (deprecated)"
[mark-control-plane] Marking the node k8s0 as control-plane by adding the taints [node-role.kubernetes.io/master:NoSchedule]
[bootstrap-token] Using token: phjpch.treepmqaxqpiivpj
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

kubeadm join 10.0.0.5:6443 --token phjpch.treepmqaxqpiivpj \
    --discovery-token-ca-cert-hash sha256:114055903215ad4f1ba34e918e1c0601f66d15be98399cbeb8a2f9c7519d50ca
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
Connection to 52.172.248.199 closed.
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/7-Persistent-Data-k8s-cluster$ ssh azureuser@$NODE1
The authenticity of host '52.172.251.175 (52.172.251.175)' can't be established.
ECDSA key fingerprint is SHA256:8Cd8HyDg33Ir/fAo9+u/6b9aQCmvbg3bolY/WUncTjk.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '52.172.251.175' (ECDSA) to the list of known hosts.
azureuser@52.172.251.175's password:
Welcome to Ubuntu 18.04.5 LTS (GNU/Linux 5.4.0-1047-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Mon Jun  7 21:14:07 UTC 2021

  System load:  0.05              Processes:              122
  Usage of /:   8.2% of 28.90GB   Users logged in:        0
  Memory usage: 4%                IP address for eth0:    10.0.0.4
  Swap usage:   0%                IP address for docker0: 172.17.0.1

42 updates can be applied immediately.
26 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

azureuser@k8s1:~$ sudo kubeadm join 10.0.0.5:6443 --token phjpch.treepmqaxqpiivpj \
>     --discovery-token-ca-cert-hash sha256:114055903215ad4f1ba34e918e1c0601f66d15be98399cbeb8a2f9c7519d50ca
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
Connection to 52.172.251.175 closed.
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/7-Persistent-Data-k8s-cluster$ ssh azureuser@$NODE0
azureuser@52.172.248.199's password:
Welcome to Ubuntu 18.04.5 LTS (GNU/Linux 5.4.0-1047-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Mon Jun  7 21:14:52 UTC 2021

  System load:  0.71               Users logged in:        0
  Usage of /:   12.8% of 28.90GB   IP address for eth0:    10.0.0.5
  Memory usage: 16%                IP address for docker0: 172.17.0.1
  Swap usage:   0%                 IP address for tunl0:   10.244.150.64
  Processes:    179


43 updates can be applied immediately.
26 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

New release '20.04.2 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Last login: Mon Jun  7 21:10:36 2021 from 20.198.3.38
azureuser@k8s0:~$ kubectl get no
NAME   STATUS   ROLES                  AGE    VERSION
k8s0   Ready    control-plane,master   3m6s   v1.20.2
k8s1   Ready    <none>                 35s    v1.20.2
azureuser@k8s0:~$ kubectl get ns
NAME              STATUS   AGE
default           Active   3m22s
kube-node-lease   Active   3m23s
kube-public       Active   3m23s
kube-system       Active   3m24s
azureuser@k8s0:~$ kubectl create ns ghost
namespace/ghost created
azureuser@k8s0:~$ kubectl get ns
NAME              STATUS   AGE
default           Active   3m56s
ghost             Active   7s
kube-node-lease   Active   3m57s
kube-public       Active   3m57s
kube-system       Active   3m58s
azureuser@k8s0:~$ vi pv.yml
azureuser@k8s0:~$ cat pv.yml
kind: PersistentVolume
apiVersion: v1
metadata:
  name: ghost-vol
  labels:
      type: local  # uses local disk from node
spec:
  capacity:
    storage: 50Gi
  accessModes:
    - ReadWriteOnce # only one node can read write at once
  hostPath:
    path: "/ghost"
azureuser@k8s0:~$ kubectl get pv
No resources found
azureuser@k8s0:~$ kubectl create -f pv.yml
persistentvolume/ghost-vol created
azureuser@k8s0:~$ kubectl get pv
NAME        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE
ghost-vol   50Gi       RWO            Retain           Available                                   5s
azureuser@k8s0:~$ vi pvc.yml
azureuser@k8s0:~$ cat pvc.yml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ghost-pv-claim
  namespace: ghost            # namespaced resource
  labels:
    app: ghost
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 50Gi
azureuser@k8s0:~$ kubectl get pvc
No resources found in default namespace.
azureuser@k8s0:~$ kubectl create -f pvc.yml
persistentvolumeclaim/ghost-pv-claim created
azureuser@k8s0:~$ kubectl get pvc
No resources found in default namespace.
azureuser@k8s0:~$ kubectl get pvc -n ghost
NAME             STATUS   VOLUME      CAPACITY   ACCESS MODES   STORAGECLASS   AGE
ghost-pv-claim   Bound    ghost-vol   50Gi       RWO                           12s
azureuser@k8s0:~$ vi deploy.yml
azureuser@k8s0:~$ cat deploy.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ghost
  namespace: ghost
  labels:
    app: ghost
    release: 4.4.0
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ghost
      release: 4.4.0
  template:
    metadata:
      labels:
        app: ghost
        release: 4.4.0
    spec:  # container spec
      volumes:
        - name: ghost-content
          persistentVolumeClaim:
            claimName: ghost-pv-claim
      containers:
        - name: ghost
          image: ghost:4.4.0
          volumeMounts:
            - name: ghost-content
              mountPath: /var/lib/ghost/content  # ghost is pv
          resources:
            limits:
              cpu: "1"
              memory: 256Mi
            requests:
              cpu: 100m
              memory: 64Mi
          ports:
            - name: http
              containerPort: 2368 # container port
              protocol: TCP
      restartPolicy: Always
azureuser@k8s0:~$ kubectl get deploy -n ghost
No resources found in ghost namespace.
azureuser@k8s0:~$ kubectl create -f deploy.yml
deployment.apps/ghost created
azureuser@k8s0:~$ kubectl get deploy
No resources found in default namespace.
azureuser@k8s0:~$ kubectl get deploy -n ghost
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
ghost   0/1     1            0           12s
azureuser@k8s0:~$ kubectl get deploy -n ghost
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
ghost   0/1     1            0           39s
azureuser@k8s0:~$ kubectl get po -n ghost
NAME                     READY   STATUS    RESTARTS   AGE
ghost-794dbb97d6-ntqjg   1/1     Running   0          48s
azureuser@k8s0:~$ vi svc.yml
azureuser@k8s0:~$ cat svc.yml
apiVersion: v1
kind: Service
metadata:
  name: ghost
  namespace: ghost
spec:
  type: NodePort
  selector:
    app: ghost  # all pods with label app-ghost
  ports:
  - protocol: TCP
    port: 80  # service port
    targetPort: 2368 # container port
azureuser@k8s0:~$ kubectl create -f svc.yml
service/ghost created
azureuser@k8s0:~$ kubectl get svc -n ghost
NAME    TYPE       CLUSTER-IP   EXTERNAL-IP   PORT(S)        AGE
ghost   NodePort   10.97.6.10   <none>        80:30709/TCP   6s
azureuser@k8s0:~$ exit
logout
Connection to 52.172.248.199 closed.
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/7-Persistent-Data-k8s-cluster$ echo $NODE1
52.172.251.175
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/7-Persistent-Data-k8s-cluster$ # Browser http://52.172.251.175:30709
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/7-Persistent-Data-k8s-cluster$ ssh azureuser@$NODE0
azureuser@52.172.248.199's password:
Welcome to Ubuntu 18.04.5 LTS (GNU/Linux 5.4.0-1047-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Mon Jun  7 21:26:49 UTC 2021

  System load:  0.63               Users logged in:        0
  Usage of /:   12.8% of 28.90GB   IP address for eth0:    10.0.0.5
  Memory usage: 16%                IP address for docker0: 172.17.0.1
  Swap usage:   0%                 IP address for tunl0:   10.244.150.64
  Processes:    168


43 updates can be applied immediately.
26 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

New release '20.04.2 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Last login: Mon Jun  7 21:14:52 2021 from 20.198.3.38
azureuser@k8s0:~$ kubectl get po -n ghost
NAME                     READY   STATUS    RESTARTS   AGE
ghost-794dbb97d6-ntqjg   1/1     Running   0          6m4s
azureuser@k8s0:~$ kubectl exec -it ghost-794dbb97d6-ntqjg -c ghost -n ghost -- /bin/bash
root@ghost-794dbb97d6-ntqjg:/var/lib/ghost# pwd
/var/lib/ghost
root@ghost-794dbb97d6-ntqjg:/var/lib/ghost# ls
config.development.json  config.production.json  content  content.orig  current  versions
root@ghost-794dbb97d6-ntqjg:/var/lib/ghost# cd content
root@ghost-794dbb97d6-ntqjg:/var/lib/ghost/content# ls
apps  data  images  logs  settings  themes
root@ghost-794dbb97d6-ntqjg:/var/lib/ghost/content# cd data/
root@ghost-794dbb97d6-ntqjg:/var/lib/ghost/content/data# ls
ghost.db
root@ghost-794dbb97d6-ntqjg:/var/lib/ghost/content/data# cd..
bash: cd..: command not found
root@ghost-794dbb97d6-ntqjg:/var/lib/ghost/content/data# cd ..
root@ghost-794dbb97d6-ntqjg:/var/lib/ghost/content# cd apps/
root@ghost-794dbb97d6-ntqjg:/var/lib/ghost/content/apps# ls
root@ghost-794dbb97d6-ntqjg:/var/lib/ghost/content/apps# cd ..
root@ghost-794dbb97d6-ntqjg:/var/lib/ghost/content# cd themes/
root@ghost-794dbb97d6-ntqjg:/var/lib/ghost/content/themes# ls
casper
root@ghost-794dbb97d6-ntqjg:/var/lib/ghost/content/themes# cd casper
root@ghost-794dbb97d6-ntqjg:/var/lib/ghost/content/themes/casper# ls
LICENSE  README.md  assets  author.hbs  default.hbs  error-404.hbs  error.hbs  gulpfile.js  index.hbs  package.json  page.hbs  partials  post.hbs  tag.hbs  yarn.lock
root@ghost-794dbb97d6-ntqjg:/var/lib/ghost/content/themes/casper# vi page.hbs
bash: vi: command not found
root@ghost-794dbb97d6-ntqjg:/var/lib/ghost/content/themes/casper# cat page.hbs
{{!< default}}

{{!-- The tag above means: insert everything in this file
into the {body} tag of the default.hbs template --}}


{{#post}}
{{!-- Everything inside the #post block pulls data from the page --}}

<article class="article {{post_class}}">

    <header class="article-header gh-canvas">
        {{#if feature_image}}
        <figure class="article-image">
            {{!-- This is a responsive image, it loads different sizes depending on device
            https://medium.freecodecamp.org/a-guide-to-responsive-images-with-ready-to-use-templates-c400bd65c433 --}}
            <img
                srcset="{{img_url feature_image size="s"}} 300w,
                        {{img_url feature_image size="m"}} 600w,
                        {{img_url feature_image size="l"}} 1000w,
                        {{img_url feature_image size="xl"}} 2000w"
                sizes="(min-width: 1400px) 1400px, 92vw"
                src="{{img_url feature_image size="xl"}}"
                alt="{{title}}"
            />
        </figure>
        {{/if}}
    </header>

    <section class="gh-content gh-canvas">

        <h1 class="article-title">{{title}}</h1>

        {{content}}

    </section>

</article>

{{/post}}root@ghost-794dbb97d6-ntqjg:/var/lib/ghost/content/themes/casper# pwd
/var/lib/ghost/content/themes/casper
root@ghost-794dbb97d6-ntqjg:/var/lib/ghost/content/themes/casper# ls
LICENSE  README.md  assets  author.hbs  default.hbs  error-404.hbs  error.hbs  gulpfile.js  index.hbs  package.json  page.hbs  partials  post.hbs  tag.hbs  yarn.lock
root@ghost-794dbb97d6-ntqjg:/var/lib/ghost/content/themes/casper# vim page.hbs
bash: vim: command not found
root@ghost-794dbb97d6-ntqjg:/var/lib/ghost/content/themes/casper# edit page.hbs
bash: edit: command not found
root@ghost-794dbb97d6-ntqjg:/var/lib/ghost/content/themes/casper# exit
exit
command terminated with exit code 127
azureuser@k8s0:~$ exit
logout
Connection to 52.172.248.199 closed.
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/7-Persistent-Data-k8s-cluster$ cd\
>
vijay@Azure:~$ ls
clouddrive  super-k8s-Learning
vijay@Azure:~$ rm -rf super-k8s-Learning/
vijay@Azure:~$ ls
clouddrive
vijay@Azure:~$ az group delete -g pvck8s-rg
Are you sure you want to perform this operation? (y/n): y
 | Running ..
```
