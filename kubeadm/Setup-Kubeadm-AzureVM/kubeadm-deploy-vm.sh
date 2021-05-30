# set env variables
resourceGroupName="kubeadm-rg"
location="centralindia"
deploymentName="kubeadm-vm-deploy"

# download template
wget https://raw.githubusercontent.com/vijayraavi/super-k8s-Learning/main/kubeadm/Setup-Kubeadm-AzureVM/kubeadm-cluster-deploy.json -O template.json

# create resource group
az group create -n $resourceGroupName -l $location

# deploy the vms
az deployment group create \
-g $resourceGroupName \
-n $deploymentName \
--template-file template.json

# list public ip
az vm list-ip-addresses -g kubeadm-rg | grep ipAddress