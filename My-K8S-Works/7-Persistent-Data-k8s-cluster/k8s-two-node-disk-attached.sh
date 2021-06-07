# set env variables
resourceGroupName="pvck8s-rg"
location="centralindia"
deploymentName="pvck8s-deploy"

# create resource group
az group create -n $resourceGroupName -l $location

# deploy the vms
az deployment group create \
-g $resourceGroupName \
-n $deploymentName \
--template-file k8s-two-node-cluster-attached-disk.json

# list public ip
az vm list-ip-addresses -g $resourceGroupName | grep ipAddress