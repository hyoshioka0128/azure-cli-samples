#!/bin/bash
# Passed validation in Bash in Docker container on Windows on 1/11/2022

# Use Bash rather than Cloud Shell due to its timeout at 20 minutes when no interactive activity 
# In Windows, run Bash in a Docker container to sync time zones between Azure and Bash.
let "randomIdentifier=$RANDOM*$RANDOM"
location="East US"
resourceGroup="msdocs-mariadb-rg-$randomIdentifier"
tags="backup-restore-mariadb"
server="msdocs-mariadb-server-$randomIdentifier"
sku="GP_Gen5_2"
restoreServer="restore-server$randomIdentifier"
login="azureuser"
password="Pa$$w0rD-$randomIdentifier"

echo "Using resource group $resourceGroup with login: $login, password: $password..."

# Create a resource group
echo "Creating $resourceGroup in $location..."
az group create --name $resourceGroup --location "$location" --tag $tag

# Create a MariaDB server in the resource group
# Name of a server maps to DNS name and is thus required to be globally unique in Azure.
echo "Creating $server in $location..."
az mariadb server create --name $server --resource-group $resourceGroup --location "$location" --admin-user $login --admin-password $password --sku-name $sku

# Sleeping  commands to wait long enough for automatic backup to be created
echo "Sleeping..."
sleep 10m

# Restore a server from backup to a new server
# To specify a specific point-in-time (in UTC) to restore from, use the ISO8601 format:
# restorePoint=“2021-07-09T13:10:00Z”
restorePoint=$(date +%s)
restorePoint=$(expr $restorePoint - 60)
restorePoint=$(date -d @$restorePoint +"%Y-%m-%dT%T")
echo $restorePoint

echo "Restoring $restoreServer"
az mariadb server restore --name $restoreServer --resource-group $resourceGroup --restore-point-in-time $restorePoint --source-server $server

# echo "Deleting all resources"
# az group delete --name $resourceGroup -y
