#!/bin/bash

RESOURCE_GROUP=$1
VM_NAME=$2

INTERFACE_ID=$(az vm show --resource-group ${RESOURCE_GROUP} --name ${VM_NAME} --query networkProfile.networkInterfaces[0].id)
INTERFACE_ID=${INTERFACE_ID:1: -1}
OS_DISK_ID=$(az vm show --resource-group ${RESOURCE_GROUP} --name ${VM_NAME} --query storageProfile.osDisk.managedDisk.id)
OS_DISK_ID=${OS_DISK_ID:1: -1}
SECURITY_GROUP_ID=$(az network nic show --id ${INTERFACE_ID} --query networkSecurityGroup.id)
SECURITY_GROUP_ID=${SECURITY_GROUP_ID:1: -1}
PUBLIC_IP_ID=$(az network nic show --id ${INTERFACE_ID} --query ipConfigurations[0].publicIpAddress.id)
PUBLIC_IP_ID=${PUBLIC_IP_ID:1: -1}

az vm delete --resource-group ${RESOURCE_GROUP} --name ${VM_NAME} --yes
echo "Deleted vm: ${VM_NAME} in resource group ${RESOURCE_GROUP}"
az network nic delete --id ${INTERFACE_ID}
echo "Deleted network interface: ${INTERFACE_ID}"
az disk delete --id ${OS_DISK_ID} --yes
echo "Deleted os disk: ${OS_DISK_ID}"
az network nsg delete --id ${SECURITY_GROUP_ID}
echo "Deleted network security group:${SECURITY_GROUP_ID}"
az network public-ip delete --id ${PUBLIC_IP_ID}
echo "Deleted public ip: ${PUBLIC_IP_ID}"