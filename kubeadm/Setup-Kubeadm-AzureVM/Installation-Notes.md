Installing a  Multi Node Cluster using kubeadm

--> open shell.azure.com

--> git clone below repo in Azure Cloud Shell
https://github.com/vijayraavi/super-k8s-Learning.git

cd kubeadm\Setup-Kubeadm-AzureVM

code .

<!-- Deploy VMs -->
--> Run Commands in kubeadm-deploy-vm.sh

<!-- List IP addresses of newly created VMs -->
az vm list-ip-addresses -g kubeadm-rg | grep ipAddress

<!-- SSH into one node (Controller Node) -->
ssh vijayk8suser@<IP address>
password: 1StrongP@ssword!

<!--  -->
--> Run commands in kubeadm-controller-up.sh
--> Copy Kubeadm join command and paste in kubeadm-nodes-up.sh

--> exit from controller node
<!-- List IP addresses of newly created VMs -->
az vm list-ip-addresses -g kubeadm-rg | grep ipAddress
<!-- SSH into one node (Worker Node)   Ctrl+R -- Search for previous commands -->
ssh vijayk8suser@<IP address>
password: 1StrongP@ssword!

--> Run commands in kubeadm-nodes-up.sh (execute kubeadm join command at last)

--> exit from worker node

--> ssh into control node and run below commands
kubectl get nodes
kubectl get all --all-namespaces
kubectl run nginx --image=nginx
kubectl get pods
kubectl get pods -o wide #(copy Ip address)
kubectl run curlpod --image=nicolaka/netshoot --rm -it -- sh  #(opens shell inside a container)
    # curl <ipaddress> --> output should be nginx home page
    exit
kubectl get pods -o wide




