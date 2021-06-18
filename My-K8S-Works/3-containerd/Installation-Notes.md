# Using containerd as the container runtime in K8S 
start https://shell.azure.com

git clone https://github.com/vijayraavi/super-k8s-Learning.git

cd super-k8s-Learning/My-K8S-Works/3-containerd


code .

# Execute commands in containerd-deploy-vm.sh  
    # list public ip
    az vm list-ip-addresses -g containerd-rg | grep ipAddress
              # "ipAddress": "xx.xxx.xxx.xxx",
    # ssh into containerDVM node
    ssh containerDVM@<IP>  -- > ssh containerDuser@20.198.2.31
    password: 1StrongP@ssword!

    # Execute commands in containerd-install.sh in containerDVM node 

    # Execute commands in containderd-k8s-install.sh in containerDVM node 
         // For containerd some additional configurations to be done
         # enable bridge networking
         # enable ip forwarding
         # load modules for storage overlay and packet filter
         # disable swap
         # pull containers for kubeadm
         # initialize the cluster
         # set config and permissions
              kubectl get no
              watch "kubectl get no"
              
         # install flannel 
                flannel is container networking interface(CNI) which will allow Nodes talking to each other.
         # view the taints
                By default when you install kubernetes this way the node has taint on it (Effect--> NoSchedule), you can see by executing below command

         # untaint the node
                After untaint node, Now you can schedule pods on this node.
         # create a deployment
                //using starter sample Container Image provided by google.

         ## By default you wont be able to access your cluster from the outside network, being that a api requires a certificate or a key/value pair that signs a certificate inorder to access the api. Thats why we setup our kubeconfig before because we specify that certificate and use it authenticate against api. so, because of this we wont be able to make a call to url path from the outside without using kubectl. we can get around this by running a proxy and this proxy communications outside the cluster, so, we can infact access the cluster.
         we can access the cluster and access the pod as part of the deployment.

         # poke a hole into the cluster and open a new tab
         # curl localhost
         # get the pod name
         # access the pod from outside the cluster

         kubectl proxy
         start/open https://shell.azure.com in new tab
         ssh containerDuser@<Node IP> -- >  -- > ssh containerDuser@20.198.2.31
         password: 1StrongP@ssword!
         # Lets access pod from API Server
         kubectl get po
         kubectl get po -o wide
         # copy pod name
         curl http://localhost:8001/api/v1/namespaces/default/pods/<name of pod>
         # we can see information of pod
         kubectl get po -o wide
         # <IP-- >
         kubectl get no -o wide
         # <InternalIP -- >

         #
         We can use this node IP address (<InternalIP -- >) to access the pod IP address (<IP-- >)
         
         Thats how we created a deployment, access our pod from outside the pod network using kubectl proxy.
         #



# SAMPLE HISTORY
###################################################################################################
vijay@Azure:~$ git clone https://github.com/vijayraavi/super-k8s-Learning.git
Cloning into 'super-k8s-Learning'...
remote: Enumerating objects: 57, done.
remote: Counting objects: 100% (57/57), done.
remote: Compressing objects: 100% (40/40), done.
remote: Total 57 (delta 25), reused 40 (delta 14), pack-reused 0
Unpacking objects: 100% (57/57), done.
vijay@Azure:~$ ls
clouddrive  super-k8s-Learning
vijay@Azure:~$ cd super-k8s-Learning/My-K8S-Works/3-containerd
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/3-containerd$ ls
containderd-k8s-install.sh  containerd-deploy-vm.sh  containerd-install.sh  containerd-single-node.json  Installation-Notes.md  install-common-tools.sh
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/3-containerd$ code .
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/3-containerd$ # Execute commands in containerd-deploy-vm.sh
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/3-containerd$ # set env variables
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/3-containerd$ resourceGroupName="containerd-rg"
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/3-containerd$ location="centralindia"
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/3-containerd$ deploymentName="containerdvm-deploy"
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/3-containerd$ # download template
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/3-containerd$ wget https://raw.githubusercontent.com/vijayraavi/super-k8s-Learning/main/My-K8S-Works/3-containerd/My-K8S-Works/3-containerd-single-node.json -O template.json
--2021-05-30 15:01:35--  https://raw.githubusercontent.com/vijayraavi/super-k8s-Learning/main/My-K8S-Works/3-containerd/My-K8S-Works/3-containerd-single-node.json
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.111.133, 185.199.108.133, 185.199.109.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.111.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 7392 (7.2K) [text/plain]
Saving to: ‘template.json’

template.json                             100%[=====================================================================================>]   7.22K  --.-KB/s    in 0s

2021-05-30 15:01:36 (60.7 MB/s) - ‘template.json’ saved [7392/7392]

vijay@Azure:~/super-k8s-Learning/My-K8S-Works/3-containerd$
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/3-containerd$ # create resource group
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/3-containerd$ az group create -n $resourceGroupName -l $location
{
  "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/My-K8S-Works/3-containerd-rg",
  "location": "centralindia",
  "managedBy": null,
  "name": "containerd-rg",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/3-containerd$
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/3-containerd$ # deploy the vms
vijay@Azure:~/super-k8s-Learning/My-K8S-Works/3-containerd$ az deployment group create \
> -g $resourceGroupName \
> -n $deploymentName \
> --template-file template.json
{
  "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/My-K8S-Works/3-containerd-rg/providers/Microsoft.Resources/deployments/containerdvm-deploy",
  "location": null,
  "name": "containerdvm-deploy",
  "properties": {
    "correlationId": "a6218a89-c26a-4420-a60d-b32c55bf2fd1",
    "debugSetting": null,
    "dependencies": [
      {
        "dependsOn": [
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/containerd-rg/providers/Microsoft.Network/networkSecurityGroups/nsg1-tdbov",
            "resourceGroup": "containerd-rg",
            "resourceName": "nsg1-tdbov",
            "resourceType": "Microsoft.Network/networkSecurityGroups"
          }
        ],
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/containerd-rg/providers/Microsoft.Network/virtualNetworks/lab-VNet1",
        "resourceGroup": "containerd-rg",
        "resourceName": "lab-VNet1",
        "resourceType": "Microsoft.Network/virtualNetworks"
      },
      {
        "dependsOn": [
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/containerd-rg/providers/Microsoft.Network/networkInterfaces/nic2-tdbov",
            "resourceGroup": "containerd-rg",
            "resourceName": "nic2-tdbov",
            "resourceType": "Microsoft.Network/networkInterfaces"
          }
        ],
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/containerd-rg/providers/Microsoft.Compute/virtualMachines/containerDVM",
        "resourceGroup": "containerd-rg",
        "resourceName": "containerDVM",
        "resourceType": "Microsoft.Compute/virtualMachines"
      },
      {
        "dependsOn": [
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/containerd-rg/providers/Microsoft.Network/publicIPAddresses/pip-lin-tdbov",
            "resourceGroup": "containerd-rg",
            "resourceName": "pip-lin-tdbov",
            "resourceType": "Microsoft.Network/publicIPAddresses"
          },
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/containerd-rg/providers/Microsoft.Network/virtualNetworks/lab-VNet1",
            "resourceGroup": "containerd-rg",
            "resourceName": "lab-VNet1",
            "resourceType": "Microsoft.Network/virtualNetworks"
          }
        ],
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/containerd-rg/providers/Microsoft.Network/networkInterfaces/nic2-tdbov",
        "resourceGroup": "containerd-rg",
        "resourceName": "nic2-tdbov",
        "resourceType": "Microsoft.Network/networkInterfaces"
      },
      {
        "dependsOn": [
          {
            "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/containerd-rg/providers/Microsoft.Compute/virtualMachines/containerDVM",
            "resourceGroup": "containerd-rg",
            "resourceName": "containerDVM",
            "resourceType": "Microsoft.Compute/virtualMachines"
          }
        ],
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/containerd-rg/providers/Microsoft.Compute/virtualMachines/containerDVM/extensions/newuserscript",
        "resourceGroup": "containerd-rg",
        "resourceName": "containerDVM/newuserscript",
        "resourceType": "Microsoft.Compute/virtualMachines/extensions"
      }
    ],
    "duration": "PT1M44.3821894S",
    "error": null,
    "mode": "Incremental",
    "onErrorDeployment": null,
    "outputResources": [
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/containerd-rg/providers/Microsoft.Compute/virtualMachines/containerDVM",
        "resourceGroup": "containerd-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/containerd-rg/providers/Microsoft.Compute/virtualMachines/containerDVM/extensions/newuserscript",
        "resourceGroup": "containerd-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/containerd-rg/providers/Microsoft.Network/networkInterfaces/nic2-tdbov",
        "resourceGroup": "containerd-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/containerd-rg/providers/Microsoft.Network/networkSecurityGroups/nsg1-tdbov",
        "resourceGroup": "containerd-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/containerd-rg/providers/Microsoft.Network/publicIPAddresses/pip-lin-tdbov",
        "resourceGroup": "containerd-rg"
      },
      {
        "id": "/subscriptions/46acb3e9-3ccf-4a40-a682-22eb0c76bc91/resourceGroups/containerd-rg/providers/Microsoft.Network/virtualNetworks/lab-VNet1",
        "resourceGroup": "containerd-rg"
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
    "templateHash": "7283846654037977611",
    "templateLink": null,
    "timestamp": "2021-05-30T15:03:24.922069+00:00",
    "validatedResources": null
  },
  "resourceGroup": "containerd-rg",
  "tags": null,
  "type": "Microsoft.Resources/deployments"
}
vijay@Azure:~/super-k8s-Learning/containerd$ # list public ip
vijay@Azure:~/super-k8s-Learning/containerd$ az vm list-ip-addresses -g containerd-rg | grep ipAddress
            "ipAddress": "20.198.2.31",

vijay@Azure:~/super-k8s-Learning/containerd$ ssh containerDuser@20.198.2.31
containerDuser@20.198.2.31's password:
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-1047-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sun May 30 15:16:56 UTC 2021

  System load:  0.0               Processes:             139
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

containerDuser@containerDVM:~$
containerDuser@containerDVM:~$ # Execute commands in containerd-install.sh in containerDVM node
containerDuser@containerDVM:~$ # install the containerd runtime
containerDuser@containerDVM:~$ sudo apt-get install containerd -y
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following additional packages will be installed:
  runc
The following NEW packages will be installed:
  containerd runc
0 upgraded, 2 newly installed, 0 to remove and 26 not upgraded.
Need to get 31.8 MB of archives.
After this operation, 146 MB of additional disk space will be used.
Get:1 http://azure.archive.ubuntu.com/ubuntu focal-updates/main amd64 runc amd64 1.0.0~rc93-0ubuntu1~20.04.2 [4018 kB]
Get:2 http://azure.archive.ubuntu.com/ubuntu focal-updates/main amd64 containerd amd64 1.3.3-0ubuntu2.3 [27.8 MB]
Fetched 31.8 MB in 3s (11.0 MB/s)
Selecting previously unselected package runc.
(Reading database ... 58428 files and directories currently installed.)
Preparing to unpack .../runc_1.0.0~rc93-0ubuntu1~20.04.2_amd64.deb ...
Unpacking runc (1.0.0~rc93-0ubuntu1~20.04.2) ...
Selecting previously unselected package containerd.
Preparing to unpack .../containerd_1.3.3-0ubuntu2.3_amd64.deb ...
Unpacking containerd (1.3.3-0ubuntu2.3) ...
Setting up runc (1.0.0~rc93-0ubuntu1~20.04.2) ...
Setting up containerd (1.3.3-0ubuntu2.3) ...
Created symlink /etc/systemd/system/multi-user.target.wants/containerd.service → /lib/systemd/system/containerd.service.
Processing triggers for man-db (2.9.1-1) ...
containerDuser@containerDVM:~$ # Configure containerd and start the service
containerDuser@containerDVM:~$ sudo mkdir -p /etc/containerd
containerDuser@containerDVM:~$ sudo su -
root@containerDVM:~# containerd config default  /etc/containerd/config.toml
version = 2
root = "/var/lib/containerd"
state = "/run/containerd"
plugin_dir = ""
disabled_plugins = []
required_plugins = []
oom_score = 0

[grpc]
  address = "/run/containerd/containerd.sock"
  tcp_address = ""
  tcp_tls_cert = ""
  tcp_tls_key = ""
  uid = 0
  gid = 0
  max_recv_message_size = 16777216
  max_send_message_size = 16777216

[ttrpc]
  address = ""
  uid = 0
  gid = 0

[debug]
  address = ""
  uid = 0
  gid = 0
  level = ""

[metrics]
  address = ""
  grpc_histogram = false

[cgroup]
  path = ""

[timeouts]
  "io.containerd.timeout.shim.cleanup" = "5s"
  "io.containerd.timeout.shim.load" = "5s"
  "io.containerd.timeout.shim.shutdown" = "3s"
  "io.containerd.timeout.task.state" = "2s"

[plugins]
  [plugins."io.containerd.gc.v1.scheduler"]
    pause_threshold = 0.02
    deletion_threshold = 0
    mutation_threshold = 100
    schedule_delay = "0s"
    startup_delay = "100ms"
  [plugins."io.containerd.grpc.v1.cri"]
    disable_tcp_service = true
    stream_server_address = "127.0.0.1"
    stream_server_port = "0"
    stream_idle_timeout = "4h0m0s"
    enable_selinux = false
    sandbox_image = "k8s.gcr.io/pause:3.1"
    stats_collect_period = 10
    systemd_cgroup = false
    enable_tls_streaming = false
    max_container_log_line_size = 16384
    disable_cgroup = false
    disable_apparmor = false
    restrict_oom_score_adj = false
    max_concurrent_downloads = 3
    disable_proc_mount = false
    [plugins."io.containerd.grpc.v1.cri".containerd]
      snapshotter = "overlayfs"
      default_runtime_name = "runc"
      no_pivot = false
      [plugins."io.containerd.grpc.v1.cri".containerd.default_runtime]
        runtime_type = ""
        runtime_engine = ""
        runtime_root = ""
        privileged_without_host_devices = false
      [plugins."io.containerd.grpc.v1.cri".containerd.untrusted_workload_runtime]
        runtime_type = ""
        runtime_engine = ""
        runtime_root = ""
        privileged_without_host_devices = false
      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes]
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
          runtime_type = "io.containerd.runc.v1"
          runtime_engine = ""
          runtime_root = ""
          privileged_without_host_devices = false
    [plugins."io.containerd.grpc.v1.cri".cni]
      bin_dir = "/opt/cni/bin"
      conf_dir = "/etc/cni/net.d"
      max_conf_num = 1
      conf_template = ""
    [plugins."io.containerd.grpc.v1.cri".registry]
      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
          endpoint = ["https://registry-1.docker.io"]
    [plugins."io.containerd.grpc.v1.cri".x509_key_pair_streaming]
      tls_cert_file = ""
      tls_key_file = ""
  [plugins."io.containerd.internal.v1.opt"]
    path = "/opt/containerd"
  [plugins."io.containerd.internal.v1.restart"]
    interval = "10s"
  [plugins."io.containerd.metadata.v1.bolt"]
    content_sharing_policy = "shared"
  [plugins."io.containerd.monitor.v1.cgroups"]
    no_prometheus = false
  [plugins."io.containerd.runtime.v1.linux"]
    shim = "containerd-shim"
    runtime = "runc"
    runtime_root = ""
    no_shim = false
    shim_debug = false
  [plugins."io.containerd.runtime.v2.task"]
    platforms = ["linux/amd64"]
  [plugins."io.containerd.service.v1.diff-service"]
    default = ["walking"]
  [plugins."io.containerd.snapshotter.v1.devmapper"]
    root_path = ""
    pool_name = ""
    base_image_size = ""
root@containerDVM:~# exit
logout
containerDuser@containerDVM:~$
containerDuser@containerDVM:~$  # Execute commands in containderd-k8s-install.sh in containerDVM node
containerDuser@containerDVM:~$ # add k8s repository GPG key
containerDuser@containerDVM:~$ curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
OK
containerDuser@containerDVM:~$ # add k8s repository
containerDuser@containerDVM:~$ sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
Hit:1 http://azure.archive.ubuntu.com/ubuntu focal InRelease
Get:2 http://azure.archive.ubuntu.com/ubuntu focal-updates InRelease [114 kB]
Get:3 http://security.ubuntu.com/ubuntu focal-security InRelease [114 kB]
Get:4 http://azure.archive.ubuntu.com/ubuntu focal-backports InRelease [101 kB]
Get:5 https://packages.cloud.google.com/apt kubernetes-xenial InRelease [9383 B]
Get:6 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 Packages [47.0 kB]
Fetched 385 kB in 2s (251 kB/s)
Reading package lists... Done
containerDuser@containerDVM:~$ # install kubelet, kubeadm and kubectl
containerDuser@containerDVM:~$ sudo apt-get install -y kubelet=1.20.2-00 kubeadm=1.20.2-00 kubectl=1.20.2-00
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
Get:2 http://azure.archive.ubuntu.com/ubuntu focal/main amd64 conntrack amd64 1:1.4.5-2 [30.3 kB]
Get:1 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 cri-tools amd64 1.13.0-01 [8775 kB]
Get:5 http://azure.archive.ubuntu.com/ubuntu focal/main amd64 ebtables amd64 2.0.11-3build1 [80.3 kB]
Get:7 http://azure.archive.ubuntu.com/ubuntu focal/main amd64 socat amd64 1.7.3.3-2 [323 kB]
Get:3 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubernetes-cni amd64 0.8.7-00 [25.0 MB]
Get:4 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubelet amd64 1.20.2-00 [18.9 MB]
Get:6 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubectl amd64 1.20.2-00 [7940 kB]
Get:8 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubeadm amd64 1.20.2-00 [7706 kB]
Fetched 68.7 MB in 11s (6058 kB/s)
Selecting previously unselected package conntrack.
(Reading database ... 58477 files and directories currently installed.)
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
containerDuser@containerDVM:~$ # enable bridge networking
containerDuser@containerDVM:~$ sudo vi /etc/sysctl.conf
# Do not accept IP source route packets (we are not a router)
#net.ipv4.conf.all.accept_source_route = 0
#net.ipv6.conf.all.accept_source_route = 0
#
# Log Martian Packets
#net.ipv4.conf.all.log_martians = 1
#

###################################################################
# Magic system request Key
# 0=disable, 1=enable all, >1 bitmask of sysrq functions
# See https://www.kernel.org/doc/html/latest/admin-guide/sysrq.html
# for what other values do
#kernel.sysrq=438
# add the following at the bottom
net.bridge.bridge-nf-call-iptables = 1
:wq!
containerDuser@containerDVM:~$ # enable ip forwarding
containerDuser@containerDVM:~$ sudo -s
root@containerDVM:/home/containerDuser# sudo echo '1' > /proc/sys/net/ipv4/ip_forward
root@containerDVM:/home/containerDuser# # Reload the configurations
root@containerDVM:/home/containerDuser# sudo sysctl --system
* Applying /etc/sysctl.d/10-console-messages.conf ...
kernel.printk = 4 4 1 7
* Applying /etc/sysctl.d/10-ipv6-privacy.conf ...
net.ipv6.conf.all.use_tempaddr = 2
net.ipv6.conf.default.use_tempaddr = 2
* Applying /etc/sysctl.d/10-kernel-hardening.conf ...
kernel.kptr_restrict = 1
* Applying /etc/sysctl.d/10-link-restrictions.conf ...
fs.protected_hardlinks = 1
fs.protected_symlinks = 1
* Applying /etc/sysctl.d/10-magic-sysrq.conf ...
kernel.sysrq = 176
* Applying /etc/sysctl.d/10-network-security.conf ...
net.ipv4.conf.default.rp_filter = 2
net.ipv4.conf.all.rp_filter = 2
* Applying /etc/sysctl.d/10-ptrace.conf ...
kernel.yama.ptrace_scope = 1
* Applying /etc/sysctl.d/10-zeropage.conf ...
vm.mmap_min_addr = 65536
* Applying /usr/lib/sysctl.d/50-default.conf ...
net.ipv4.conf.default.promote_secondaries = 1
sysctl: setting key "net.ipv4.conf.all.promote_secondaries": Invalid argument
net.ipv4.ping_group_range = 0 2147483647
net.core.default_qdisc = fq_codel
fs.protected_regular = 1
fs.protected_fifos = 1
* Applying /usr/lib/sysctl.d/50-pid-max.conf ...
kernel.pid_max = 4194304
* Applying /etc/sysctl.d/99-cloudimg-ipv6.conf ...
net.ipv6.conf.all.use_tempaddr = 0
net.ipv6.conf.default.use_tempaddr = 0
* Applying /etc/sysctl.d/99-sysctl.conf ...
* Applying /usr/lib/sysctl.d/protect-links.conf ...
fs.protected_fifos = 1
fs.protected_hardlinks = 1
fs.protected_regular = 2
fs.protected_symlinks = 1
* Applying /etc/sysctl.conf ...
root@containerDVM:/home/containerDuser# # load modules for storage overlay and packet filter
root@containerDVM:/home/containerDuser# sudo modprobe overlay
root@containerDVM:/home/containerDuser# sudo modprobe br_netfilter
root@containerDVM:/home/containerDuser# # disable swap
root@containerDVM:/home/containerDuser# sudo swapoff -a
root@containerDVM:/home/containerDuser# # pull containers for kubeadm
root@containerDVM:/home/containerDuser# sudo kubeadm config images pull
I0530 15:25:05.945272   15927 version.go:251] remote version is much newer: v1.21.1; falling back to: stable-1.20
[config/images] Pulled k8s.gcr.io/kube-apiserver:v1.20.7
[config/images] Pulled k8s.gcr.io/kube-controller-manager:v1.20.7
[config/images] Pulled k8s.gcr.io/kube-scheduler:v1.20.7
[config/images] Pulled k8s.gcr.io/kube-proxy:v1.20.7
[config/images] Pulled k8s.gcr.io/pause:3.2
[config/images] Pulled k8s.gcr.io/etcd:3.4.13-0
[config/images] Pulled k8s.gcr.io/coredns:1.7.0
root@containerDVM:/home/containerDuser# # initialize the cluster
root@containerDVM:/home/containerDuser# sudo kubeadm init --pod-network-cidr=10.244.0.0/16
I0530 15:25:55.441588   16093 version.go:251] remote version is much newer: v1.21.1; falling back to: stable-1.20
[init] Using Kubernetes version: v1.20.7
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [containerdvm kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs[10.96.0.1 10.0.0.4]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [containerdvm localhost] and IPs [10.0.0.4 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [containerdvm localhost] and IPs [10.0.0.4 127.0.0.1 ::1]
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
[apiclient] All control plane components are healthy after 26.001692 seconds
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config-1.20" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node containerdvm as control-plane by adding the labels "node-role.kubernetes.io/master=''" and "node-role.kubernetes.io/control-plane='' (deprecated)"
[mark-control-plane] Marking the node containerdvm as control-plane by adding the taints [node-role.kubernetes.io/master:NoSchedule]
[bootstrap-token] Using token: pmfljc.hijujbnyr2n673e9
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

kubeadm join 10.0.0.4:6443 --token pmfljc.hijujbnyr2n673e9 \
    --discovery-token-ca-cert-hash sha256:ebf97a49350e45002844bf693a80902defde516bf2eafeb357152a88556e42b2
root@containerDVM:/home/containerDuser#

root@containerDVM:/home/containerDuser# # set config and permissions
root@containerDVM:/home/containerDuser# mkdir -p $HOME/.kube
root@containerDVM:/home/containerDuser# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
root@containerDVM:/home/containerDuser# sudo chown $(id -u):$(id -g) $HOME/.kube/config
root@containerDVM:/home/containerDuser# # install flannel
root@containerDVM:/home/containerDuser# kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
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
root@containerDVM:/home/containerDuser# # view the taints
root@containerDVM:/home/containerDuser# kubectl get nodes -o=custom-columns=NODE:.metadata.name,KEY:.spec.taints[*].key,VALUE:.spec.taints[*].value,EFFECT:.spec.taints[*].effect
NODE           KEY                                                           VALUE    EFFECT
containerdvm   node-role.kubernetes.io/master,node.kubernetes.io/not-ready   <none>   NoSchedule,NoSchedule
root@containerDVM:/home/containerDuser# # untaint the node
root@containerDVM:/home/containerDuser# kubectl taint no containerdvm node-role.kubernetes.io/master:NoSchedule-
node/containerdvm untainted
root@containerDVM:/home/containerDuser# kubectl get nodes -o=custom-columns=NODE:.metadata.name,KEY:.spec.taints[*].key,VALUE:.spec.taints[*].value,EFFECT:.spec.taints[*].effect
NODE           KEY      VALUE    EFFECT
containerdvm   <none>   <none>   <none>
root@containerDVM:/home/containerDuser# # create a deployment
root@containerDVM:/home/containerDuser# kubectl create deploy connector --image gcr.io/google-samples/kubernetes-bootcamp:v1
deployment.apps/connector created
root@containerDVM:/home/containerDuser# kubectl get no
NAME           STATUS   ROLES                  AGE     VERSION
containerdvm   Ready    control-plane,master   3m41s   v1.20.2
root@containerDVM:/home/containerDuser# kubectl get no -o wide
NAME           STATUS   ROLES                  AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
containerdvm   Ready    control-plane,master   3m45s   v1.20.2   10.0.0.4      <none>        Ubuntu 20.04.2 LTS   5.4.0-1047-azure   containerd://1.3.3-0ubuntu2.3

root@containerDVM:/home/containerDuser# # poke a hole into the cluster and open a new tab
root@containerDVM:/home/containerDuser# kubectl proxy
Starting to serve on 127.0.0.1:8001



start/open https://shell.azure.com in new tab
         ssh containerDuser@<Node IP> -- >  -- > ssh containerDuser@20.198.2.31
         password: 1StrongP@ssword!

$ ssh containerDuser@20.198.2.31
The authenticity of host '20.198.2.31 (20.198.2.31)' can't be established.
ECDSA key fingerprint is SHA256:o/Xer5UAXNAXMfcpPvMjGcAXjNULo1jhbFM4m9fV7B0.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '20.198.2.31' (ECDSA) to the list of known hosts.
containerDuser@20.198.2.31's password:
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-1047-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sun May 30 15:33:40 UTC 2021

  System load:  0.23               Processes:              196
  Usage of /:   13.5% of 28.90GB   Users logged in:        1
  Memory usage: 33%                IPv4 address for eth0:  10.0.0.4
  Swap usage:   0%                 IPv4 address for tunl0: 10.244.247.0

 * Super-optimized for small spaces - read how we shrank the memory
   footprint of MicroK8s to make it the smallest full K8s around.

   https://ubuntu.com/blog/microk8s-memory-optimisation

29 updates can be applied immediately.
12 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable


Last login: Sun May 30 15:16:57 2021 from 20.204.6.192
containerDuser@containerDVM:~$




###################################################################################################










