# Using containerd as the container runtime in K8S 
start https://shell.azure.com

git clone https://github.com/vijayraavi/super-k8s-Learning.git

cd super-k8s-Learning/containerd


code .

# Execute commands in containerd-deploy-vm.sh  
    # list public ip
    az vm list-ip-addresses -g containerd-rg | grep ipAddress
              # "ipAddress": "xx.xxx.xxx.xxx",
    # ssh into containerDVM node
    ssh containerDVM@<IP>  -- > ssh containerDVM@
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
         # install flannel 
                flannel is container networking interface which will allow Nodes talking to each other.
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
         ssh containerDuser@<Node IP>
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
         
         Thats how we created a deployment, access our pod from outside of cluster using kubectl proxy.
         #



# SAMPLE HISTORY
###################################################################################################

###################################################################################################










