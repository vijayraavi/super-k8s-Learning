# set env variables
resourceGroupName="containerd-rg"
location="centralindia"
deploymentName="containerdvm-deploy"

# download template
wget https://raw.githubusercontent.com/vijayraavi/super-k8s-Learning/main/My-K8S-Works/3-containerd/containerd-single-node.json -O template.json

# create resource group
az group create -n $resourceGroupName -l $location

# deploy the vms
az deployment group create \
-g $resourceGroupName \
-n $deploymentName \
--template-file template.json

# list public ip
az vm list-ip-addresses -g containerd-rg | grep ipAddress
