Installing a  Multi Node Cluster using kubeadm

--> open shell.azure.com

--> git clone below repo in Azure Cloud Shell
https://github.com/vijayraavi/super-k8s-Learning.git

git clone https://github.com/vijayraavi/super-k8s-Learning.git

cd super-k8s-Learning/kubeadm/Setup-Kubeadm-AzureVM

code .

# Deploy VMs -->
--> Run Commands in kubeadm-deploy-vm.sh

# List IP addresses of newly created VMs -->
az vm list-ip-addresses -g kubeadm-rg | grep ipAddress
<!--  Sample donot use below-
    # "ipAddress": "20.193.238.177" -- > Controller Node
    # "ipAddress": "20.193.238.75" -- > Worker Node
-->

# SSH into one node (Controller Node) -->
ssh vijayk8suser@<IP address> --> ssh vijayk8suser@20.193.238.177
password: 1StrongP@ssword!

<!--  -->
--> Run commands in kubeadm-controller-up.sh
--> Copy Kubeadm join command and paste in kubeadm-nodes-up.sh

# Sample by adding sudo -- donot use below
sudo kubeadm join 10.0.0.5:6443 --token 0l1vc2.hgia9vlcu6q3kfci \
    --discovery-token-ca-cert-hash sha256:c4e145a964dd224bf5dc827e82d764ab30002df8794e2918185c7332664da14d
 -->

--> exit from controller node
# List IP addresses of newly created VMs -->
az vm list-ip-addresses -g kubeadm-rg | grep ipAddress
# SSH into one node (Worker Node)   Ctrl+R -- Search for previous commands -->
ssh vijayk8suser@<IP address> --> ssh vijayk8suser@20.193.238.75
password: 1StrongP@ssword!

--> Run commands in kubeadm-nodes-up.sh (execute kubeadm join command at last using elevated privilages sudo)
# Sample donot use below
sudo kubeadm join 10.0.0.5:6443 --token 0l1vc2.hgia9vlcu6q3kfci \
    --discovery-token-ca-cert-hash sha256:c4e145a964dd224bf5dc827e82d764ab30002df8794e2918185c7332664da14d
 -->

--> exit from worker node

--> ssh into control node and run below commands 
# ssh vijayk8suser@<IP address> -- > ssh vijayk8suser@20.193.238.177 -->
kubectl get nodes
kubectl get all --all-namespaces
kubectl run nginx --image=nginx
kubectl get pods
kubectl get pods -o wide #(copy Ip address)
kubectl run curlpod --image=nicolaka/netshoot --rm -it -- sh  #(opens shell inside a container)
    # curl <ipaddress> --> output should be nginx home page
    exit
kubectl get pods -o wide

# Sample history -->
#################################################################################################
$ ssh vijayk8suser@20.193.238.177
The authenticity of host '20.193.238.177 (20.193.238.177)' can't be established.
ECDSA key fingerprint is SHA256:qyCGtO90s2tumFXzHP/gv3loa8oRShYMRCTOWs6C1No.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '20.193.238.177' (ECDSA) to the list of known hosts.
vijayk8suser@20.193.238.177's password:
Welcome to Ubuntu 18.04.5 LTS (GNU/Linux 5.4.0-1047-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sun May 30 08:30:16 UTC 2021

  System load:  0.05               Users logged in:        1
  Usage of /:   12.8% of 28.90GB   IP address for eth0:    10.0.0.5
  Memory usage: 33%                IP address for docker0: 172.17.0.1
  Swap usage:   0%                 IP address for tunl0:   10.244.150.64
  Processes:    170


23 updates can be applied immediately.
9 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

New release '20.04.2 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Last login: Sun May 30 08:07:43 2021 from 20.193.232.103
vijayk8suser@k8s0:~$ kubecyl get nodes

Command 'kubecyl' not found, did you mean:

  command 'kubectl' from snap kubectl (1.21.1)

See 'snap info <snapname>' for additional versions.

vijayk8suser@k8s0:~$ kubectl get nodes
NAME   STATUS   ROLES    AGE     VERSION
k8s0   Ready    master   18m     v1.19.9
k8s1   Ready    <none>   7m11s   v1.19.9
vijayk8suser@k8s0:~$ kubectl get no
NAME   STATUS   ROLES    AGE     VERSION
k8s0   Ready    master   18m     v1.19.9
k8s1   Ready    <none>   7m15s   v1.19.9
vijayk8suser@k8s0:~$ kubectl get no -o wide
NAME   STATUS   ROLES    AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
k8s0   Ready    master   18m     v1.19.9   10.0.0.5      <none>        Ubuntu 18.04.5 LTS   5.4.0-1047-azure   docker://20.10.6
k8s1   Ready    <none>   7m19s   v1.19.9   10.0.0.4      <none>        Ubuntu 18.04.5 LTS   5.4.0-1047-azure   docker://20.10.6
vijayk8suser@k8s0:~$ kubectl get all --all-namespaces
NAMESPACE     NAME                                           READY   STATUS    RESTARTS   AGE
kube-system   pod/calico-kube-controllers-7f4f5bf95d-jqrvr   1/1     Running   0          18m
kube-system   pod/calico-node-8vqj7                          1/1     Running   0          18m
kube-system   pod/calico-node-cfp47                          1/1     Running   0          8m48s
kube-system   pod/coredns-f9fd979d6-6f9lg                    1/1     Running   0          19m
kube-system   pod/coredns-f9fd979d6-qt6sm                    1/1     Running   0          19m
kube-system   pod/etcd-k8s0                                  1/1     Running   0          19m
kube-system   pod/kube-apiserver-k8s0                        1/1     Running   0          19m
kube-system   pod/kube-controller-manager-k8s0               1/1     Running   0          19m
kube-system   pod/kube-proxy-7qd7f                           1/1     Running   0          8m48s
kube-system   pod/kube-proxy-shc4c                           1/1     Running   0          19m
kube-system   pod/kube-scheduler-k8s0                        1/1     Running   0          19m

NAMESPACE     NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                  AGE
default       service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP                  19m
kube-system   service/kube-dns     ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP,9153/TCP   19m

NAMESPACE     NAME                         DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
kube-system   daemonset.apps/calico-node   2         2         2       2            2           kubernetes.io/os=linux   18m
kube-system   daemonset.apps/kube-proxy    2         2         2       2            2           kubernetes.io/os=linux   19m

NAMESPACE     NAME                                      READY   UP-TO-DATE   AVAILABLE   AGE
kube-system   deployment.apps/calico-kube-controllers   1/1     1            1           18m
kube-system   deployment.apps/coredns                   2/2     2            2           19m

NAMESPACE     NAME                                                 DESIRED   CURRENT   READY   AGE
kube-system   replicaset.apps/calico-kube-controllers-7f4f5bf95d   1         1         1       18m
kube-system   replicaset.apps/coredns-f9fd979d6                    2         2         2       19m
vijayk8suser@k8s0:~$ kubectl run nginx --image=nginx
pod/nginx created
vijayk8suser@k8s0:~$ kubectl get po
NAME    READY   STATUS              RESTARTS   AGE
nginx   0/1     ContainerCreating   0          7s
vijayk8suser@k8s0:~$ kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          23s
vijayk8suser@k8s0:~$ kubectl get po -o wide
NAME    READY   STATUS    RESTARTS   AGE   IP               NODE   NOMINATED NODE   READINESS GATES
nginx   1/1     Running   0          29s   10.244.166.193   k8s1   <none>           <none>
vijayk8suser@k8s0:~$ #IP 10.244.166.193
vijayk8suser@k8s0:~$ kubectl run curlpod --image=nicolaka/netshoot --rm -it -- sh
If you don't see a command prompt, try pressing enter.
~ # curl 10.244.166.193
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
~ # exit
Session ended, resume using 'kubectl attach curlpod -c curlpod -i -t' command when the pod is running
pod "curlpod" deleted
vijayk8suser@k8s0:~$ kubectl get po -o wide
NAME    READY   STATUS    RESTARTS   AGE     IP               NODE   NOMINATED NODE   READINESS GATES
nginx   1/1     Running   0          3m24s   10.244.166.193   k8s1   <none>           <none>
vijayk8suser@k8s0:~$

#################################################################################################




