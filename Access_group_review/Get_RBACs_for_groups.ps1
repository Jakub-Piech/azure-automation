<#

List RBACs that this group directly has. 
! Watchout for line 42 & 43 - one is for groups and another for users
.

.EXAMPLE
# :by Group Name
$GroupNames = @(
'T1G-CDHG-CoreDataHub-Core-Engineers-Admin'
)
Access_group_review/Get_RBACs_for_groups.ps1 -i $GroupNames

#>
[CmdletBinding(DefaultParametersetName = 'default')]
param (
    [Alias('i')]
    [Parameter(Mandatory, ParameterSetName = 'ByName')]
    [System.Object]$GroupNames
)

process {
$subs = Get-AzSubscription
$allAssignments = @()       # creates an empty array for the variable
foreach ($sub in $subs) {   # for each subscription from the the subscription list $sub is the newly created variable
    set-azcontext -Subscription $sub.Name # set a subscription as a context for executing this task
    foreach ($GroupName in $GroupNames) {
        $grId = (Get-AzADGroup -DisplayName $GroupName).Id     # for groups
#        $grId = (Get-AzADUser -DisplayName $GroupName).Id       # for people
        $GroupName
        $assignments = Get-AzRoleAssignment -ObjectId $grId
        foreach ($assignment in $assignments) { # output file creation
            $Object = New-Object PSObject
            $Object | Add-Member -MemberType NoteProperty -Name "DisplayName" -Value $assignment.DisplayName
            $Object | Add-Member -MemberType NoteProperty -Name "RoleDefinitionName" -Value $assignment.RoleDefinitionName
            $Object | Add-Member -MemberType NoteProperty -Name "Scope" -Value $assignment.Scope
            $a = $assignment | Select-Object -ExpandProperty Scope -first 1
            if($a -match "subscription"){
                $id = $a.Replace("/subscriptions/","")
                $submgm = (Get-AzSubscription -SubscriptionId $id).Name
            }
            else {
                $submgm = (Get-AzManagementGroup | Where-Object {$_.Id -match $assignment.Scope}).DisplayName
            }
            $Object | Add-Member -MemberType NoteProperty -Name "Name" -Value $submgm
            $allAssignments += $Object
        }
    }
}
}

end{
    $date = Get-Date -Format "dd_MM_yyyy"
    $allAssignments | Sort-Object -Property Scope,DisplayName,RoleDefinitionName -Unique | Export-Csv -Path "Access_group_review/Get_RBACs_for_groups_$date.csv"
}


