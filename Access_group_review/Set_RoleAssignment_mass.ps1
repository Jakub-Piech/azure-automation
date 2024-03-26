<#

Set mass role Assignment

.EXAMPLE
# :parameters
$Role = 'PG KeyVault Contributor'
$Scopes = @(
'/subscriptions/291ef65c-7e27-40f6-b09e-45063b043560/resourceGroups/AZ-RG-AirflowPlatform-Res-test-NonProd-01/providers/Microsoft.KeyVault/vaults/kv-orch-test-t3',
'/subscriptions/291ef65c-7e27-40f6-b09e-45063b043560/resourceGroups/AZ-RG-AirflowPlatform-Test-01/providers/Microsoft.KeyVault/vaults/adfpoc-airflow',
'/subscriptions/291ef65c-7e27-40f6-b09e-45063b043560/resourceGroups/AZ-RG-AirflowPlatform-test-Orch-44/providers/Microsoft.KeyVault/vaults/kv-orch-test-44',
'/subscriptions/291ef65c-7e27-40f6-b09e-45063b043560/resourceGroups/AZ-RG-AirflowPlatform-test-Orch-55/providers/Microsoft.KeyVault/vaults/kv-orch-test-55'
)
$AzADGroup = 'IDHG-All-AirflowPlatform-Admins'


# :run script
Temp/Access_group_review/Set_RoleAssignment_mass.ps1 -r $Role -s $Scopes -g $AzADGroup

#>
[CmdletBinding()]
param (
    [Alias('r')]
    [Parameter(Mandatory)]
    [String]$Role,

    [Alias('s')]
    [Parameter(Mandatory)]
    [System.Object]$Scopes,

    [Alias('g')]
    [Parameter(Mandatory)]
    [String]$AzADGroup
)


process {
    $id = (Get-AzADGroup -DisplayName $AzADGroup).Id
    foreach ($Scope in $Scopes) {
        $assigned = Get-AzRoleAssignment -RoleDefinitionName $Role -Scope $Scope -ObjectId $id | Where-Object {$_.Scope -eq $Scope}

    if (-not $assigned) {
            New-AzRoleAssignment -RoleDefinitionName $Role -Scope $Scope -ObjectId $id
    }
    }
}

end{

}


