<#

List RBACs that this group directly has
Prerequisite:
Install-Module Microsoft.Graph
Install-Module AzureAD
Install-Module AzureADPreview

& relog
! Watchout for line 30 & 31 one is for groups and another for users

.EXAMPLE
# :by Group Name
$GroupNames = @(
'znalezniak, maciej [Non-PG]',
'Tier1-znalezniak, maciej'
)
Access_group_review/Get_memberships_of_groups.ps1 -i $GroupNames

#>
[CmdletBinding(DefaultParametersetName = 'default')]
param (
    [Alias('i')]
    [Parameter(Mandatory, ParameterSetName = 'ByName')]
    [System.Object]$GroupNames
)

process {
    Connect-MgGraph
    $GroupMembers= @()

    foreach ($GroupName in $GroupNames) {
#        $Groups2 = Get-MgGroupTransitiveMemberOf -GroupId (Get-AzADGroup -DisplayName $GroupName).Id  # for groups
        $Groups2 = Get-MgUserMemberOf -UserId (Get-AzADUser -DisplayName $GroupName).Id  # for users
        foreach ($Group2 in $Groups2) {
            $Group2name = (Get-AzADGroup -ObjectId $Group2.Id).DisplayName
            $Object = New-Object PSObject
            $Object | Add-Member -MemberType NoteProperty -Name "Searched Group Name" -Value $GroupName
            $Object | Add-Member -MemberType NoteProperty -Name "Searched Group Id" -Value (Get-AzADGroup -DisplayName $GroupName).Id
            $Object | Add-Member -MemberType NoteProperty -Name "Higher Group Name" -Value $Group2name
            $Object | Add-Member -MemberType NoteProperty -Name "Higher Group Id" -Value $Group2.Id
            $Object
            $GroupMembers += $Object
        }
    }
}

end{
    $date = Get-Date -Format "dd_MM_yyyy"
    $GroupMembers | Export-Csv -Path "Access_group_review/Get_memberships_of_groups_$date.csv"
}