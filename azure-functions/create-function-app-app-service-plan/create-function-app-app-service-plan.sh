#!/bin/bash
# Passed validation in Cloud Shell on 3/24/2022

# <FullScript>
# Function app and storage account names must be unique.

# Variable block
let "randomIdentifier=$RANDOM*$RANDOM"
location="eastus"
resourceGroup="msdocs-azure-functions-rg-$randomIdentifier"
tags="create-function-app-consumption"
storage="msdocsaccount$randomIdentifier"
appServicePlan="msdocs-app-service-plan-$randomIdentifier"
functionApp="msdocs-serverless-function-$randomIdentifier"
skuStorage="Standard_LRS"
skuPlan="B1"
functionsVersion="4"

# Create a resource group
echo "Creating $resourceGroup in "$location"..."
az group create --name $resourceGroup --location "$location" --tags $tag

# Create an Azure storage account in the resource group.
echo "Creating $storage"
az storage account create --name $storage --location "$location" --resource-group $resourceGroup --sku $skuStorage

# Create an App Service plan
echo "Creating $appServicePlan"
az functionapp plan create --name $appServicePlan --resource-group $resourceGroup --location "$location" --sku $skuPlan

# Create a Function App
echo "Creating $functionApp"
az functionapp create --name $functionApp --storage-account $storage --plan $appServicePlan --resource-group $resourceGroup --functions-version $functionsVersion
# </FullScript>

# echo "Deleting all resources"
# az group delete --name $resourceGroup -y
