# 5 - Using a Sidecar container to collect logs from two seperate streams in K8S
start https://shell.azure.com

git clone https://github.com/vijayraavi/super-k8s-Learning.git

cd super-k8s-Learning/containerd


code .

# Execute commands in sidecar-deploy.sh

    ## Benifits of using docker containers is, all the container logs automatically streamed to std in, stg out by default. In K8S, Kubelet keeps track of this when running those docker containers, but the problem is when container dies, our logs go away with it.
    -->To Solve this Stram those logs to Node.
    -->Kubelet will handle straming those logs by writing on the node.
    -->Create a logging container in the form of a sidecar.
    -->A Sidecar container is just multiple containers in one pod.
    -->Sidecar container/logging container will be able to stram those logs from the main application.

    
