# 5 - Using a Sidecar container to collect logs from two seperate streams in K8S
start https://shell.azure.com

git clone https://github.com/vijayraavi/super-k8s-Learning.git

cd super-k8s-Learning/My-K8S-Works/5-Sidecar-Container-Logs


code .



# Execute commands in sidecar-deploy.sh

    ## Benifits of using docker containers is, all the container logs automatically streamed to std in, stg out by default. In K8S, Kubelet keeps track of this when running those docker containers, but the problem is when container dies, our logs go away with it.
    -->To Solve this Stram those logs to Node.
    -->Kubelet will handle straming those logs by writing on the node.
    -->Create a logging container in the form of a sidecar.
    -->A Sidecar container is just multiple containers in one pod.
    -->Sidecar container/logging container will be able to stram those logs from the main application.

# list public ip
az vm list-ip-addresses -g sidecar-rg | grep ipAddress
     --> "ipAddress": "52.172.254.33",

--> ssh K8Suser@<IP> --> ssh K8Suser@52.172.254.33
password: 1StrongP@ssword!

### After Installing flannel ( Container Network Interface - CNI )

# Get Node name, details and remove taint on node
kubectl get no
kubectl taint no k8svm node-role.kubernetes.io/master:NoSchedule-


# deploy the pod
kubectl create -f sidecar-pod.yml

kubectl get po

# access logs from the first container
kubectl logs counter count-log-1

# access logs from the second container
kubectl logs counter count-log-2

    

## Deployed Pod which contains 3 containers
    - 1 Application Container
    - 2 containers - Logging output for two different log streams 


# SAMPLE HISTORY
###################################################################################################
Requesting a Cloud Shell.Succeeded.
Connecting terminal...

vijay@Azure:~$
vijay@Azure:~$ git clone https://github.com/vijayraavi/super-k8s-Learning.git
fatal: destination path 'super-k8s-Learning' already exists and is not an empty directory.
vijay@Azure:~$ ls
clouddrive  super-k8s-Learning
vijay@Azure:~$ rm -rf super-k8s-Learning/
vijay@Azure:~$ git clone https://github.com/vijayraavi/super-k8s-Learning.git
Cloning into 'super-k8s-Learning'...
remote: Enumerating objects: 93, done.
remote: Counting objects: 100% (93/93), done.
remote: Compressing objects: 100% (68/68), done.
remote: Total 93 (delta 41), reused 67 (delta 21), pack-reused 0
Unpacking objects: 100% (93/93), done.
vijay@Azure:~$ cd super-k8s-Learning/My-K8S-Works/5-Sidecar-Container-Logs
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/5-Sidecar-Container-Logs$ ls
5-Notes.md  calico.yaml  install-common-tools.sh  sidecar-deploy.sh  sidecare-arm-deploy.json  sidecar-pod.yml
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/5-Sidecar-Container-Logs$ code .
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/5-Sidecar-Container-Logs$ wget https://raw.githubusercontent.com/vijayraavi/super-k8s-Learning/main/My-K8S-Works/5-Sidecar-Container-Logs/sidecare-arm-deploy.json -O template.json
--2021-05-31 17:45:39--  https://raw.githubusercontent.com/vijayraavi/super-k8s-Learning/main/My-K8S-Works/5-Sidecar-Container-Logs/sidecare-arm-deploy.json
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.111.133, 185.199.108.133, 185.199.109.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.111.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 7399 (7.2K) [text/plain]
Saving to: ‘template.json’

template.json                             100%[=====================================================================================>]   7.23K  --.-KB/s    in 0s

2021-05-31 17:45:40 (52.6 MB/s) - ‘template.json’ saved [7399/7399]

vijay@Azure:~/super-k8s-Learning/My-K8S-Works/5-Sidecar-Container-Logs$ code .
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/5-Sidecar-Container-Logs$ # set env variables
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/5-Sidecar-Container-Logs$ resourceGroupName="sidecar-rg"
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/5-Sidecar-Container-Logs$ location="centralindia"
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/5-Sidecar-Container-Logs$ deploymentName="sidecar-deploy"
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/5-Sidecar-Container-Logs$
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/5-Sidecar-Container-Logs$ # create resource group
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/5-Sidecar-Container-Logs$ az group create -n $resourceGroupName -l $location
{
  "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/sidecar-rg",
  "location": "centralindia",
  "managedBy": null,
  "name": "sidecar-rg",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/5-Sidecar-Container-Logs$
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/5-Sidecar-Container-Logs$ # deploy the vms
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/5-Sidecar-Container-Logs$ az deployment group create \
> -g $resourceGroupName \
> -n $deploymentName \
> --template-file template.json
{
  "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/sidecar-rg/providers/Microsoft.Resources/deployments/sidecar-deploy",
  "location": null,
  "name": "sidecar-deploy",
  "properties": {
    "correlationId": "74a054ca-1840-4523-b903-0c92470e7f0c",
    "debugSetting": null,
    "dependencies": [
      {
        "dependsOn": [
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/sidecar-rg/providers/Microsoft.Network/networkSecurityGroups/nsg1-feqpz",
            "resourceGroup": "sidecar-rg",
            "resourceName": "nsg1-feqpz",
            "resourceType": "Microsoft.Network/networkSecurityGroups"
          }
        ],
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/sidecar-rg/providers/Microsoft.Network/virtualNetworks/lab-VNet1",
        "resourceGroup": "sidecar-rg",
        "resourceName": "lab-VNet1",
        "resourceType": "Microsoft.Network/virtualNetworks"
      },
      {
        "dependsOn": [
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/sidecar-rg/providers/Microsoft.Network/networkInterfaces/nic2-feqpz",
            "resourceGroup": "sidecar-rg",
            "resourceName": "nic2-feqpz",
            "resourceType": "Microsoft.Network/networkInterfaces"
          }
        ],
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/sidecar-rg/providers/Microsoft.Compute/virtualMachines/k8sVM",
        "resourceGroup": "sidecar-rg",
        "resourceName": "k8sVM",
        "resourceType": "Microsoft.Compute/virtualMachines"
      },
      {
        "dependsOn": [
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/sidecar-rg/providers/Microsoft.Network/publicIPAddresses/pip-lin-feqpz",
            "resourceGroup": "sidecar-rg",
            "resourceName": "pip-lin-feqpz",
            "resourceType": "Microsoft.Network/publicIPAddresses"
          },
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/sidecar-rg/providers/Microsoft.Network/virtualNetworks/lab-VNet1",
            "resourceGroup": "sidecar-rg",
            "resourceName": "lab-VNet1",
            "resourceType": "Microsoft.Network/virtualNetworks"
          }
        ],
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/sidecar-rg/providers/Microsoft.Network/networkInterfaces/nic2-feqpz",
        "resourceGroup": "sidecar-rg",
        "resourceName": "nic2-feqpz",
        "resourceType": "Microsoft.Network/networkInterfaces"
      },
      {
        "dependsOn": [
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/sidecar-rg/providers/Microsoft.Compute/virtualMachines/k8sVM",
            "resourceGroup": "sidecar-rg",
            "resourceName": "k8sVM",
            "resourceType": "Microsoft.Compute/virtualMachines"
          }
        ],
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/sidecar-rg/providers/Microsoft.Compute/virtualMachines/k8sVM/extensions/newuserscript",
        "resourceGroup": "sidecar-rg",
        "resourceName": "k8sVM/newuserscript",
        "resourceType": "Microsoft.Compute/virtualMachines/extensions"
      }
    ],
    "duration": "PT1M6.2228344S",
    "error": null,
    "mode": "Incremental",
    "onErrorDeployment": null,
    "outputResources": [
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/sidecar-rg/providers/Microsoft.Compute/virtualMachines/k8sVM",
        "resourceGroup": "sidecar-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/sidecar-rg/providers/Microsoft.Compute/virtualMachines/k8sVM/extensions/newuserscript",
        "resourceGroup": "sidecar-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/sidecar-rg/providers/Microsoft.Network/networkInterfaces/nic2-feqpz",
        "resourceGroup": "sidecar-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/sidecar-rg/providers/Microsoft.Network/networkSecurityGroups/nsg1-feqpz",
        "resourceGroup": "sidecar-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/sidecar-rg/providers/Microsoft.Network/publicIPAddresses/pip-lin-feqpz",
        "resourceGroup": "sidecar-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/sidecar-rg/providers/Microsoft.Network/virtualNetworks/lab-VNet1",
        "resourceGroup": "sidecar-rg"
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
            "resourceType": "publicIPAddresses",
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
    "templateHash": "6966013479722037007",
    "templateLink": null,
    "timestamp": "2021-05-31T17:48:14.133475+00:00",
    "validatedResources": null
  },
  "resourceGroup": "sidecar-rg",
  "tags": null,
  "type": "Microsoft.Resources/deployments"
}
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/5-Sidecar-Container-Logs$ # list public ip
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/5-Sidecar-Container-Logs$ az vm list-ip-addresses -g sidecar-rg | grep ipAddress
            "ipAddress": "52.172.254.33",
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/5-Sidecar-Container-Logs$ ssh K8Suser@52.172.254.33
The authenticity of host '52.172.254.33 (52.172.254.33)' can't be established.
ECDSA key fingerprint is SHA256:DGXWfvu/Qgpj9AVs/r+8DSLy1ulwweLYuhUEGwhP+90.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '52.172.254.33' (ECDSA) to the list of known hosts.
K8Suser@52.172.254.33's password:
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-1047-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Mon May 31 17:54:15 UTC 2021

  System load:  0.0               Processes:             142
  Usage of /:   4.9% of 28.90GB   Users logged in:       0
  Memory usage: 7%                IPv4 address for eth0: 10.0.0.4
  Swap usage:   0%

26 updates can be applied immediately.
12 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

K8Suser@k8sVM:~$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
OK
K8Suser@k8sVM:~$ sudo add-apt-repository \
>    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
>    $(lsb_release -cs) \
>    stable"
Hit:1 http://azure.archive.ubuntu.com/ubuntu focal InRelease
Hit:2 http://azure.archive.ubuntu.com/ubuntu focal-updates InRelease
Hit:3 http://azure.archive.ubuntu.com/ubuntu focal-backports InRelease
Get:4 https://download.docker.com/linux/ubuntu focal InRelease [41.0 kB]
Get:5 https://download.docker.com/linux/ubuntu focal/stable amd64 Packages [9335 B]
Hit:6 http://security.ubuntu.com/ubuntu focal-security InRelease
Fetched 50.3 kB in 0s (103 kB/s)
Reading package lists... Done
K8Suser@k8sVM:~$ # Add Kubernetes gpg key
K8Suser@k8sVM:~$ curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
OK
K8Suser@k8sVM:~$ cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
> deb https://apt.kubernetes.io/ kubernetes-xenial main
> EOF
deb https://apt.kubernetes.io/ kubernetes-xenial main
K8Suser@k8sVM:~$ sudo apt-get update
Hit:1 http://azure.archive.ubuntu.com/ubuntu focal InRelease
Hit:2 http://azure.archive.ubuntu.com/ubuntu focal-updates InRelease
Hit:3 http://azure.archive.ubuntu.com/ubuntu focal-backports InRelease
Hit:4 https://download.docker.com/linux/ubuntu focal InRelease
Hit:6 http://security.ubuntu.com/ubuntu focal-security InRelease
Get:5 https://packages.cloud.google.com/apt kubernetes-xenial InRelease [9383 B]
Get:7 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 Packages [47.0 kB]
Fetched 56.4 kB in 1s (44.7 kB/s)
Reading package lists... Done
K8Suser@k8sVM:~$ sudo apt-get install -y containerd.io docker-ce=5:20.10.6~3-0~ubuntu-$(lsb_release -cs)
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following additional packages will be installed:
  docker-ce-cli docker-ce-rootless-extras docker-scan-plugin pigz slirp4netns
Suggested packages:
  aufs-tools cgroupfs-mount | cgroup-lite
The following NEW packages will be installed:
  containerd.io docker-ce docker-ce-cli docker-ce-rootless-extras docker-scan-plugin pigz slirp4netns
0 upgraded, 7 newly installed, 0 to remove and 26 not upgraded.
Need to get 108 MB of archives.
After this operation, 466 MB of additional disk space will be used.
Get:1 http://azure.archive.ubuntu.com/ubuntu focal/universe amd64 pigz amd64 2.4-1 [57.4 kB]
Get:2 https://download.docker.com/linux/ubuntu focal/stable amd64 containerd.io amd64 1.4.6-1 [28.3 MB]
Get:3 http://azure.archive.ubuntu.com/ubuntu focal/universe amd64 slirp4netns amd64 0.4.3-1 [74.3 kB]
Get:4 https://download.docker.com/linux/ubuntu focal/stable amd64 docker-ce-cli amd64 5:20.10.6~3-0~ubuntu-focal [41.4 MB]
Get:5 https://download.docker.com/linux/ubuntu focal/stable amd64 docker-ce amd64 5:20.10.6~3-0~ubuntu-focal [24.8 MB]
Get:6 https://download.docker.com/linux/ubuntu focal/stable amd64 docker-ce-rootless-extras amd64 5:20.10.6~3-0~ubuntu-focal [9067 kB]
Get:7 https://download.docker.com/linux/ubuntu focal/stable amd64 docker-scan-plugin amd64 0.7.0~ubuntu-focal [3886 kB]
Fetched 108 MB in 2s (53.7 MB/s)
Selecting previously unselected package pigz.
(Reading database ... 58428 files and directories currently installed.)
Preparing to unpack .../0-pigz_2.4-1_amd64.deb ...
Unpacking pigz (2.4-1) ...
Selecting previously unselected package containerd.io.
Preparing to unpack .../1-containerd.io_1.4.6-1_amd64.deb ...
Unpacking containerd.io (1.4.6-1) ...
Selecting previously unselected package docker-ce-cli.
Preparing to unpack .../2-docker-ce-cli_5%3a20.10.6~3-0~ubuntu-focal_amd64.deb ...
Unpacking docker-ce-cli (5:20.10.6~3-0~ubuntu-focal) ...
Selecting previously unselected package docker-ce.
Preparing to unpack .../3-docker-ce_5%3a20.10.6~3-0~ubuntu-focal_amd64.deb ...
Unpacking docker-ce (5:20.10.6~3-0~ubuntu-focal) ...
Selecting previously unselected package docker-ce-rootless-extras.
Preparing to unpack .../4-docker-ce-rootless-extras_5%3a20.10.6~3-0~ubuntu-focal_amd64.deb ...
Unpacking docker-ce-rootless-extras (5:20.10.6~3-0~ubuntu-focal) ...
Selecting previously unselected package docker-scan-plugin.
Preparing to unpack .../5-docker-scan-plugin_0.7.0~ubuntu-focal_amd64.deb ...
Unpacking docker-scan-plugin (0.7.0~ubuntu-focal) ...
Selecting previously unselected package slirp4netns.
Preparing to unpack .../6-slirp4netns_0.4.3-1_amd64.deb ...
Unpacking slirp4netns (0.4.3-1) ...
Setting up slirp4netns (0.4.3-1) ...
Setting up docker-scan-plugin (0.7.0~ubuntu-focal) ...
Setting up containerd.io (1.4.6-1) ...
Created symlink /etc/systemd/system/multi-user.target.wants/containerd.service → /lib/systemd/system/containerd.service.
Setting up docker-ce-cli (5:20.10.6~3-0~ubuntu-focal) ...
Setting up pigz (2.4-1) ...
Setting up docker-ce-rootless-extras (5:20.10.6~3-0~ubuntu-focal) ...
Setting up docker-ce (5:20.10.6~3-0~ubuntu-focal) ...
Created symlink /etc/systemd/system/multi-user.target.wants/docker.service → /lib/systemd/system/docker.service.
Created symlink /etc/systemd/system/sockets.target.wants/docker.socket → /lib/systemd/system/docker.socket.
Processing triggers for man-db (2.9.1-1) ...
Processing triggers for systemd (245.4-4ubuntu3.6) ...
K8Suser@k8sVM:~$ sudo apt-get install -y kubelet=1.20.2-00 kubeadm=1.20.2-00 kubectl=1.20.2-00
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following additional packages will be installed:
  conntrack cri-tools ebtables kubernetes-cni socat
Suggested packages:
  nftables
The following NEW packages will be installed:
  conntrack cri-tools ebtables kubeadm kubectl kubelet kubernetes-cni socat
0 upgraded, 8 newly installed, 0 to remove and 26 not upgraded.
Need to get 68.7 MB of archives.
After this operation, 293 MB of additional disk space will be used.
Get:1 http://azure.archive.ubuntu.com/ubuntu focal/main amd64 conntrack amd64 1:1.4.5-2 [30.3 kB]
Get:2 http://azure.archive.ubuntu.com/ubuntu focal/main amd64 ebtables amd64 2.0.11-3build1 [80.3 kB]
Get:3 http://azure.archive.ubuntu.com/ubuntu focal/main amd64 socat amd64 1.7.3.3-2 [323 kB]
Get:4 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 cri-tools amd64 1.13.0-01 [8775 kB]
Get:5 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubernetes-cni amd64 0.8.7-00 [25.0 MB]
Get:6 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubelet amd64 1.20.2-00 [18.9 MB]
Get:7 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubectl amd64 1.20.2-00 [7940 kB]
Get:8 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubeadm amd64 1.20.2-00 [7706 kB]
Fetched 68.7 MB in 12s (5616 kB/s)
Selecting previously unselected package conntrack.
(Reading database ... 58678 files and directories currently installed.)
Preparing to unpack .../0-conntrack_1%3a1.4.5-2_amd64.deb ...
Unpacking conntrack (1:1.4.5-2) ...
Selecting previously unselected package cri-tools.
Preparing to unpack .../1-cri-tools_1.13.0-01_amd64.deb ...
Unpacking cri-tools (1.13.0-01) ...
Selecting previously unselected package ebtables.
Preparing to unpack .../2-ebtables_2.0.11-3build1_amd64.deb ...
Unpacking ebtables (2.0.11-3build1) ...
Selecting previously unselected package kubernetes-cni.
Preparing to unpack .../3-kubernetes-cni_0.8.7-00_amd64.deb ...
Unpacking kubernetes-cni (0.8.7-00) ...
Selecting previously unselected package socat.
Preparing to unpack .../4-socat_1.7.3.3-2_amd64.deb ...
Unpacking socat (1.7.3.3-2) ...
Selecting previously unselected package kubelet.
Preparing to unpack .../5-kubelet_1.20.2-00_amd64.deb ...
Unpacking kubelet (1.20.2-00) ...
Selecting previously unselected package kubectl.
Preparing to unpack .../6-kubectl_1.20.2-00_amd64.deb ...
Unpacking kubectl (1.20.2-00) ...
Selecting previously unselected package kubeadm.
Preparing to unpack .../7-kubeadm_1.20.2-00_amd64.deb ...
Unpacking kubeadm (1.20.2-00) ...
Setting up conntrack (1:1.4.5-2) ...
Setting up kubectl (1.20.2-00) ...
Setting up ebtables (2.0.11-3build1) ...
Setting up socat (1.7.3.3-2) ...
Setting up cri-tools (1.13.0-01) ...
Setting up kubernetes-cni (0.8.7-00) ...
Setting up kubelet (1.20.2-00) ...
Created symlink /etc/systemd/system/multi-user.target.wants/kubelet.service → /lib/systemd/system/kubelet.service.
Setting up kubeadm (1.20.2-00) ...
Processing triggers for man-db (2.9.1-1) ...
K8Suser@k8sVM:~$ sudo apt-mark hold kubelet kubeadm kubectl
kubelet set on hold.
kubeadm set on hold.
kubectl set on hold.
K8Suser@k8sVM:~$ sudo kubeadm init --pod-network-cidr=10.244.0.0/16
I0531 17:56:57.955720    5449 version.go:251] remote version is much newer: v1.21.1; falling back to: stable-1.20
[init] Using Kubernetes version: v1.20.7
[preflight] Running pre-flight checks
        [WARNING IsDockerSystemdCheck]: detected "cgroupfs" as the Docker cgroup driver. The recommended driver is "systemd". Please follow the guide at https://kubernetes.io/docs/setup/cri/
        [WARNING SystemVerification]: this Docker version is not on the list of validated versions: 20.10.6. Latest validated version: 19.03
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [k8svm kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 10.0.0.4]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [k8svm localhost] and IPs [10.0.0.4 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [k8svm localhost] and IPs [10.0.0.4 127.0.0.1 ::1]
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
[apiclient] All control plane components are healthy after 8.502130 seconds
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config-1.20" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node k8svm as control-plane by adding the labels "node-role.kubernetes.io/master=''" and "node-role.kubernetes.io/control-plane='' (deprecated)"
[mark-control-plane] Marking the node k8svm as control-plane by adding the taints [node-role.kubernetes.io/master:NoSchedule]
[bootstrap-token] Using token: bxzmkr.ot8f4r141prbpz3t
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

kubeadm join 10.0.0.4:6443 --token bxzmkr.ot8f4r141prbpz3t \
    --discovery-token-ca-cert-hash sha256:8d3292b5e4765258266247fc3e51557c306dfdcb78046bcbdd3402425d71ff76
K8Suser@k8sVM:~$ mkdir -p $HOME/.kube
K8Suser@k8sVM:~$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
K8Suser@k8sVM:~$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
K8Suser@k8sVM:~$ kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
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
K8Suser@k8sVM:~$ wget https://raw.githubusercontent.com/vijayraavi/super-k8s-Learning/main/My-K8S-Works/5-Sidecar-Container-Logs/sidecar-pod.yml
--2021-05-31 17:58:24--  https://raw.githubusercontent.com/vijayraavi/super-k8s-Learning/main/My-K8S-Works/5-Sidecar-Container-Logs/sidecar-pod.yml
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.111.133, 185.199.108.133, 185.199.109.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.111.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 760 [text/plain]
Saving to: ‘sidecar-pod.yml’

sidecar-pod.yml                           100%[=====================================================================================>]     760  --.-KB/s    in 0s

2021-05-31 17:58:24 (49.0 MB/s) - ‘sidecar-pod.yml’ saved [760/760]

K8Suser@k8sVM:~$ kubectl taint no node1 node-role.kubernetes.io/master:NoSchedule-
Error from server (NotFound): nodes "node1" not found
K8Suser@k8sVM:~$ kubectl get no
NAME    STATUS   ROLES                  AGE    VERSION
k8svm   Ready    control-plane,master   117s   v1.20.2
K8Suser@k8sVM:~$ kubectl get no
NAME    STATUS   ROLES                  AGE     VERSION
k8svm   Ready    control-plane,master   4m13s   v1.20.2
K8Suser@k8sVM:~$
K8Suser@k8sVM:~$ kubectl taint no K8svm node-role.kubernetes.io/master:NoSchedule-
Error from server (NotFound): nodes "K8svm" not found
K8Suser@k8sVM:~$ kubectl taint no k8svm node-role.kubernetes.io/master:NoSchedule-
node/k8svm untainted
K8Suser@k8sVM:~$ kubectl create -f sidecar-pod.yml
pod/counter created
K8Suser@k8sVM:~$ kubectl get po
NAME      READY   STATUS              RESTARTS   AGE
counter   0/3     ContainerCreating   0          10s
K8Suser@k8sVM:~$ watch "kubectl get po"
K8Suser@k8sVM:~$ watch "kubectl get po"
K8Suser@k8sVM:~$ kubectl logs counter count-log-1
0: Mon May 31 18:05:47 UTC 2021
1: Mon May 31 18:05:48 UTC 2021
2: Mon May 31 18:05:49 UTC 2021
3: Mon May 31 18:05:50 UTC 2021
4: Mon May 31 18:05:51 UTC 2021
5: Mon May 31 18:05:52 UTC 2021
6: Mon May 31 18:05:53 UTC 2021
7: Mon May 31 18:05:54 UTC 2021
8: Mon May 31 18:05:55 UTC 2021
9: Mon May 31 18:05:56 UTC 2021
10: Mon May 31 18:05:57 UTC 2021
11: Mon May 31 18:05:58 UTC 2021
12: Mon May 31 18:05:59 UTC 2021
13: Mon May 31 18:06:00 UTC 2021
14: Mon May 31 18:06:01 UTC 2021
15: Mon May 31 18:06:02 UTC 2021
16: Mon May 31 18:06:03 UTC 2021
17: Mon May 31 18:06:04 UTC 2021
18: Mon May 31 18:06:05 UTC 2021
19: Mon May 31 18:06:06 UTC 2021
20: Mon May 31 18:06:07 UTC 2021
21: Mon May 31 18:06:08 UTC 2021
22: Mon May 31 18:06:09 UTC 2021
23: Mon May 31 18:06:10 UTC 2021
24: Mon May 31 18:06:11 UTC 2021
25: Mon May 31 18:06:12 UTC 2021
26: Mon May 31 18:06:13 UTC 2021
27: Mon May 31 18:06:14 UTC 2021
28: Mon May 31 18:06:15 UTC 2021
29: Mon May 31 18:06:16 UTC 2021
30: Mon May 31 18:06:17 UTC 2021
31: Mon May 31 18:06:18 UTC 2021
32: Mon May 31 18:06:19 UTC 2021
33: Mon May 31 18:06:20 UTC 2021
34: Mon May 31 18:06:21 UTC 2021
35: Mon May 31 18:06:22 UTC 2021
36: Mon May 31 18:06:23 UTC 2021
37: Mon May 31 18:06:24 UTC 2021
38: Mon May 31 18:06:25 UTC 2021
39: Mon May 31 18:06:26 UTC 2021
40: Mon May 31 18:06:27 UTC 2021
41: Mon May 31 18:06:28 UTC 2021
42: Mon May 31 18:06:29 UTC 2021
43: Mon May 31 18:06:30 UTC 2021
44: Mon May 31 18:06:31 UTC 2021
45: Mon May 31 18:06:32 UTC 2021
46: Mon May 31 18:06:33 UTC 2021
47: Mon May 31 18:06:34 UTC 2021
48: Mon May 31 18:06:35 UTC 2021
49: Mon May 31 18:06:36 UTC 2021
50: Mon May 31 18:06:37 UTC 2021
51: Mon May 31 18:06:38 UTC 2021
52: Mon May 31 18:06:39 UTC 2021
53: Mon May 31 18:06:40 UTC 2021
54: Mon May 31 18:06:41 UTC 2021
55: Mon May 31 18:06:42 UTC 2021
56: Mon May 31 18:06:43 UTC 2021
57: Mon May 31 18:06:44 UTC 2021
58: Mon May 31 18:06:45 UTC 2021
59: Mon May 31 18:06:46 UTC 2021
60: Mon May 31 18:06:47 UTC 2021
61: Mon May 31 18:06:48 UTC 2021
62: Mon May 31 18:06:49 UTC 2021
63: Mon May 31 18:06:50 UTC 2021
64: Mon May 31 18:06:51 UTC 2021
65: Mon May 31 18:06:52 UTC 2021
66: Mon May 31 18:06:53 UTC 2021
67: Mon May 31 18:06:54 UTC 2021
68: Mon May 31 18:06:55 UTC 2021
69: Mon May 31 18:06:56 UTC 2021
70: Mon May 31 18:06:57 UTC 2021
71: Mon May 31 18:06:58 UTC 2021
72: Mon May 31 18:06:59 UTC 2021
73: Mon May 31 18:07:00 UTC 2021
74: Mon May 31 18:07:01 UTC 2021
75: Mon May 31 18:07:02 UTC 2021
76: Mon May 31 18:07:03 UTC 2021
77: Mon May 31 18:07:04 UTC 2021
78: Mon May 31 18:07:05 UTC 2021
79: Mon May 31 18:07:06 UTC 2021
80: Mon May 31 18:07:07 UTC 2021
81: Mon May 31 18:07:08 UTC 2021
82: Mon May 31 18:07:09 UTC 2021
83: Mon May 31 18:07:10 UTC 2021
84: Mon May 31 18:07:11 UTC 2021
85: Mon May 31 18:07:12 UTC 2021
86: Mon May 31 18:07:13 UTC 2021
K8Suser@k8sVM:~$ kubectl logs counter count-log-2
Mon May 31 18:05:47 UTC 2021 INFO 0
Mon May 31 18:05:48 UTC 2021 INFO 1
Mon May 31 18:05:49 UTC 2021 INFO 2
Mon May 31 18:05:50 UTC 2021 INFO 3
Mon May 31 18:05:51 UTC 2021 INFO 4
Mon May 31 18:05:52 UTC 2021 INFO 5
Mon May 31 18:05:53 UTC 2021 INFO 6
Mon May 31 18:05:54 UTC 2021 INFO 7
Mon May 31 18:05:55 UTC 2021 INFO 8
Mon May 31 18:05:56 UTC 2021 INFO 9
Mon May 31 18:05:57 UTC 2021 INFO 10
Mon May 31 18:05:58 UTC 2021 INFO 11
Mon May 31 18:05:59 UTC 2021 INFO 12
Mon May 31 18:06:00 UTC 2021 INFO 13
Mon May 31 18:06:01 UTC 2021 INFO 14
Mon May 31 18:06:02 UTC 2021 INFO 15
Mon May 31 18:06:03 UTC 2021 INFO 16
Mon May 31 18:06:04 UTC 2021 INFO 17
Mon May 31 18:06:05 UTC 2021 INFO 18
Mon May 31 18:06:06 UTC 2021 INFO 19
Mon May 31 18:06:07 UTC 2021 INFO 20
Mon May 31 18:06:08 UTC 2021 INFO 21
Mon May 31 18:06:09 UTC 2021 INFO 22
Mon May 31 18:06:10 UTC 2021 INFO 23
Mon May 31 18:06:11 UTC 2021 INFO 24
Mon May 31 18:06:12 UTC 2021 INFO 25
Mon May 31 18:06:13 UTC 2021 INFO 26
Mon May 31 18:06:14 UTC 2021 INFO 27
Mon May 31 18:06:15 UTC 2021 INFO 28
Mon May 31 18:06:16 UTC 2021 INFO 29
Mon May 31 18:06:17 UTC 2021 INFO 30
Mon May 31 18:06:18 UTC 2021 INFO 31
Mon May 31 18:06:19 UTC 2021 INFO 32
Mon May 31 18:06:20 UTC 2021 INFO 33
Mon May 31 18:06:21 UTC 2021 INFO 34
Mon May 31 18:06:22 UTC 2021 INFO 35
Mon May 31 18:06:23 UTC 2021 INFO 36
Mon May 31 18:06:24 UTC 2021 INFO 37
Mon May 31 18:06:25 UTC 2021 INFO 38
Mon May 31 18:06:26 UTC 2021 INFO 39
Mon May 31 18:06:27 UTC 2021 INFO 40
Mon May 31 18:06:28 UTC 2021 INFO 41
Mon May 31 18:06:29 UTC 2021 INFO 42
Mon May 31 18:06:30 UTC 2021 INFO 43
Mon May 31 18:06:31 UTC 2021 INFO 44
Mon May 31 18:06:32 UTC 2021 INFO 45
Mon May 31 18:06:33 UTC 2021 INFO 46
Mon May 31 18:06:34 UTC 2021 INFO 47
Mon May 31 18:06:35 UTC 2021 INFO 48
Mon May 31 18:06:36 UTC 2021 INFO 49
Mon May 31 18:06:37 UTC 2021 INFO 50
Mon May 31 18:06:38 UTC 2021 INFO 51
Mon May 31 18:06:39 UTC 2021 INFO 52
Mon May 31 18:06:40 UTC 2021 INFO 53
Mon May 31 18:06:41 UTC 2021 INFO 54
Mon May 31 18:06:42 UTC 2021 INFO 55
Mon May 31 18:06:43 UTC 2021 INFO 56
Mon May 31 18:06:44 UTC 2021 INFO 57
Mon May 31 18:06:45 UTC 2021 INFO 58
Mon May 31 18:06:46 UTC 2021 INFO 59
Mon May 31 18:06:47 UTC 2021 INFO 60
Mon May 31 18:06:48 UTC 2021 INFO 61
Mon May 31 18:06:49 UTC 2021 INFO 62
Mon May 31 18:06:50 UTC 2021 INFO 63
Mon May 31 18:06:51 UTC 2021 INFO 64
Mon May 31 18:06:52 UTC 2021 INFO 65
Mon May 31 18:06:53 UTC 2021 INFO 66
Mon May 31 18:06:54 UTC 2021 INFO 67
Mon May 31 18:06:55 UTC 2021 INFO 68
Mon May 31 18:06:56 UTC 2021 INFO 69
Mon May 31 18:06:57 UTC 2021 INFO 70
Mon May 31 18:06:58 UTC 2021 INFO 71
Mon May 31 18:06:59 UTC 2021 INFO 72
Mon May 31 18:07:00 UTC 2021 INFO 73
Mon May 31 18:07:01 UTC 2021 INFO 74
Mon May 31 18:07:02 UTC 2021 INFO 75
Mon May 31 18:07:03 UTC 2021 INFO 76
Mon May 31 18:07:04 UTC 2021 INFO 77
Mon May 31 18:07:05 UTC 2021 INFO 78
Mon May 31 18:07:06 UTC 2021 INFO 79
Mon May 31 18:07:07 UTC 2021 INFO 80
Mon May 31 18:07:08 UTC 2021 INFO 81
Mon May 31 18:07:09 UTC 2021 INFO 82
Mon May 31 18:07:10 UTC 2021 INFO 83
Mon May 31 18:07:11 UTC 2021 INFO 84
Mon May 31 18:07:12 UTC 2021 INFO 85
Mon May 31 18:07:13 UTC 2021 INFO 86
Mon May 31 18:07:14 UTC 2021 INFO 87
Mon May 31 18:07:15 UTC 2021 INFO 88
Mon May 31 18:07:16 UTC 2021 INFO 89
Mon May 31 18:07:17 UTC 2021 INFO 90
Mon May 31 18:07:18 UTC 2021 INFO 91
Mon May 31 18:07:19 UTC 2021 INFO 92
Mon May 31 18:07:20 UTC 2021 INFO 93
Mon May 31 18:07:21 UTC 2021 INFO 94
Mon May 31 18:07:22 UTC 2021 INFO 95
Mon May 31 18:07:23 UTC 2021 INFO 96
Mon May 31 18:07:24 UTC 2021 INFO 97
Mon May 31 18:07:25 UTC 2021 INFO 98
Mon May 31 18:07:26 UTC 2021 INFO 99
Mon May 31 18:07:27 UTC 2021 INFO 100
Mon May 31 18:07:28 UTC 2021 INFO 101
Mon May 31 18:07:29 UTC 2021 INFO 102
K8Suser@k8sVM:~$