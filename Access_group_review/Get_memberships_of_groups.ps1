<#

List RBACs that this group directly has
Preriequisite:
Install-Module Microsoft.Graph

.EXAMPLE
# :by Group Name
$GroupNames = @(
'znalezniak, maciej [Non-PG]',
'Tier1-znalezniak, maciej'
)
Temp/Access_group_review/Get_memberships_of_groups.ps1 -i $GroupNames

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
        $Groups2 = Get-MgGroupTransitiveMemberOf -GroupId (Get-AzADGroup -DisplayName $GroupName).Id
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
    $GroupMembers | Export-Csv -Path "Temp/Access_group_review/Get_memberships_of_groups_$date.csv"
}