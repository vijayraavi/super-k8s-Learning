# set env variables
resourceGroupName="k8s-rg"
location="centralindia"
deploymentName="k8s-twonode-deploy"

# create resource group
az group create -n $resourceGroupName -l $location

# deploy the vms
az deployment group create \
-g $resourceGroupName \
-n $deploymentName \
--template-file k8s-two-node-cluster-deploy.json

# list public ip
az vm list-ip-addresses -g $resourceGroupName | grep ipAddress 

