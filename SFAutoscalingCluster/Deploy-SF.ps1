Param(  
    # Name of the subscription to use for azure cmdlets
    $subscriptionName = "stephgou - External",
    $subscriptionId = "fb79eb46-411c-4097-86ba-801dca0ff5d5",
    #Paramètres du Azure Ressource Group
    $resourceGroupName = "SG-RG-SF-Autoscale",
    $resourceGroupDeploymentName = "SF-Deployed",
    $resourceLocation = "West Europe",
    $templateFile = "autoscaledeploy.json",
    $templateParameterFile = "azuredeploy.parameters.json",
    $tagName = "SG-RG-SF",
    $tagValue = "Autoscale"
    )

#region init
Set-PSDebug -Strict

#((Get-AzureRmResourceProvider -ProviderNamespace Microsoft.Network).ResourceTypes | Where-Object ResourceTypeName -eq virtualNetworks).ApiVersions
#| Where-Object ResourceTypeName -eq availabilitySets).ApiVersions
#((Get-AzureRmResourceProvider -ProviderNamespace Microsoft.Resources).ResourceTypes | Where-Object ResourceTypeName -eq deployments).ApiVersions
#((Get-AzureRmResourceProvider -ProviderNamespace Microsoft.Storage).ResourceTypes | Where-Object ResourceTypeName -eq storageAccounts).ApiVersions

#((Get-AzureRmResourceProvider -ProviderNamespace Microsoft.Compute).ResourceTypes | Where-Object ResourceTypeName -eq disks).ApiVersions

cls
$d = get-date
#Write-((Get-AzureRmResourceProvider -ProviderNamespace Microsoft.Network).ResourceTypes | Where-Object ResourceTypeName -eq LoadBalancers).ApiVersions
#((Get-AzureRmResourceProvider -ProviderNamespace Microsoft.Network).ResourceTypes | Where-Object ResourceTypeName -eq publicIPAddresses).ApiVersions
#((Get-AzureRmResourceProvider -ProviderNamespace Microsoft.Network).ResourceTypes | Where-Object ResourceTypeName -eq virtualNetworkGateways).ApiVersions
#((Get-AzureRmResourceProvider -ProviderNamespace Microsoft.Network).ResourceTypes | Where-Object ResourceTypeName -eq networkInterfaces).ApiVersions
#((Get-AzureRmResourceProvider -ProviderNamespace Microsoft.Compute).ResourceTypes | Where-Object ResourceTypeName -eq virtualMachines).ApiVersions
#((Get-AzureRmResourceProvider -ProviderNamespace Microsoft.Compute).ResourceTypes 

Write-Host "Starting Deployment $d"

$scriptFolder = Split-Path -Parent $MyInvocation.MyCommand.Definition
Write-Host "scriptFolder" $scriptFolder

set-location $scriptFolder
#endregion init

Login-AzureRmAccount -SubscriptionId $subscriptionId

# Resource group create
New-AzureRmResourceGroup `
	-Name $resourceGroupName `
	-Location $resourceLocation `
    -Tag @{Name=$tagName;Value=$tagValue} `
    -Verbose

# Resource group deploy
New-AzureRmResourceGroupDeployment `
    -Name $resourceGroupDeploymentName `
	-ResourceGroupName $resourceGroupName `
	-TemplateFile "$scriptFolder\$templateFile" `
	-TemplateParameterFile "$scriptFolder\$templateParameterFile" `
    -Debug -Verbose -DeploymentDebugLogLevel All

$d = get-date
Write-Host "Stopping Deployment $d"