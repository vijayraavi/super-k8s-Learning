#!/bin/bash

# This script prepares a generic Kubernetes 1.15.7 server with kubeadm.
# It is configured with the assumption that flannel will be used for networking.

# Designed for Ubuntu 18.04 LTS

# Update the apt package index
sudo apt-get update

# Install packages to allow apt to use a repository over HTTPS
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Set up the Docker stable repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Add Kubernetes gpg key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Add Kubernetes stable repository
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# Update the apt package index
sudo apt-get update

# Install the 19.03.4 version of Docker Engine - Community
sudo apt-get install -y containerd.io docker-ce=5:20.10.6~3-0~ubuntu-$(lsb_release -cs)

# Install kubelet, kubeadm and kubectl packages
sudo apt-get install -y kubelet=1.20.2-00 kubeadm=1.20.2-00 kubectl=1.20.2-00

# hold package versions
sudo apt-mark hold docker-ce kubelet kubeadm kubectl

# Setup daemon.
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

sudo mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
sudo systemctl daemon-reload
sudo systemctl restart docker

# download flannel config
sudo wget -O /root/kube-flannel.yml https://docs.projectcalico.org/manifests/calico.yaml

# download init script for control plane node
sudo wget -O /home/azureuser/k8s-initialize-cluster.sh https://raw.githubusercontent.com/vijayraavi/super-k8s-Learning/main/My-K8S-Works/7-Persistent-Data-k8s-cluster/k8s-initialize-cluster.sh