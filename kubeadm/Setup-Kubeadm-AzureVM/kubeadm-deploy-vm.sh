# set env variables
resourceGroupName="kubeadm-rg"
location="centralindia"
deploymentName="kubeadm-vm-deploy"

# download template
wget https://raw.githubusercontent.com/vijayraavi/super-k8s-Learning/main/kubeadm/Setup-Kubeadm-AzureVM/kubeadm-cluster-deploy.json -O template.json

# change location, username, password in template file

# create resource group
az group create -n $resourceGroupName -l $location

# deploy the vms
az deployment group create \
-g $resourceGroupName \
-n $deploymentName \
--template-file template.json

# # OR Execute below with default values for deploying VMS
# az deployment group create \
# -g $resourceGroupName \
# -n $deploymentName \
# --template-file kubeadm-cluster-deploy.json


# list public ip
az vm list-ip-addresses -g kubeadm-rg | grep ipAddress
    # "ipAddress": "20.193.238.177",
    # "ipAddress": "20.193.238.75",