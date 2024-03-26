install-module az.Resourcegraph
Search-AzGraph -Query "ResourceContainers | where type =~ 'microsoft.resources/subscriptions'" -ManagementGroup 'eaaeb1e6-247d-4585-8bb9-3fa6b06b469e' | ForEach-Object { $_ | Select-Object name, subscriptionId }
winget install --id git.git
git init
git config --global user.name 'Jakub Piech'
git config --global user.email 'piech.j@pg.com'

code -r "$home/.ssh/id_rsa.pub"
code -r "$home/.ssh/id_rsa"
Get-AzRoleDefinition -Name "PG ResourceGroup Admin" | ConvertTo-Json -Depth 8 
scripts/Get-RoleDefinition.ps1 -f 'Microsoft.Synapse/*' -Custom | ConvertTo-Json -Depth 8  #find what actioins have this in description

######
Get-AzProviderOperation -OperationSearchString Microsoft.AnalysisServices/servers/read | Format-Table #find what operations have this part inside
Get-AzProviderOperation -OperationSearchString Microsoft.Resources/* | Format-Table #find what oparations have this part inside
######

# git update
git --version
winget install --id git.git


ssh -i piech.j@pg.com 10.118.64.19



# Oauth token - reprezentuje mnie i to co moge zrobic
Connect-AzAccount
Get-AzAccessToken


#####
$
Get-AzRoleAssignment -RoleDefinitionId "" | Format-Table

Get-AzRoleAssignment -ObjectId "" | Format-Table

set-azcontext -Subscription "PG-NA-External-NonProd-03"
Get-AzDBforMySqlServerFirewallRule -ResourceGroupName "AZ-RG-PGACOE-DEV-01" -ServerName "acoepopdev"

# Get resources in Azure Vnet

$subID=""
$RG=""
$vnet=""

$subnets = (Get-AzVirtualNetwork -Name $vnet -ResourceGroupName $RG).Subnets
$subnets.Name
$resources = Get-AzResource -ResourceGroupName $RG | Where-Object { $_.ResourceId -match $vnet.Id }
$resources


$resourceGroupName = "AZ-RG-PG-NA-EXTERNAL-EASTUS2-NONPROD-07-Network"
$subnetName = "AZ-VN-NA-EASTUS2-EXTERNAL-NonProd-07-vnet-SN-Use-01"
$VirtualNetwork = Get-AzVirtualNetwork -Name "AZ-VN-NA-EASTUS2-EXTERNAL-NonProd-07-vnet" -ResourceGroupName "AZ-RG-PG-NA-EXTERNAL-EASTUS2-NONPROD-07-Network"

$subnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $VirtualNetwork -Name $subnetName
$subnet.Id





