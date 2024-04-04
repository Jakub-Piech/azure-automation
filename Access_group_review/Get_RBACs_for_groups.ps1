<#

List RBACs that this group directly has

.EXAMPLE
# :by Group Name
$GroupNames = @(
'IDHG-DXC-AirFlow-Admins',
'DNS-SelfService-AirflowPlatform',
'IDHG-All-AirflowPlatform-Admins',
'ITSG-CSE-EmbeddedEngineers',
'ITSG-SophieCSE-PG',
'ITSG-SophieCSE-Ext',
'ITS-SophieCSE',
'ITS-Sophie-Users',
'GITG-askPG-Cloud-admins',
'GITG-askPG-Cloud-users',
'GTOG-VICA-ADMINS',
'ITSG-CSE-ADOUsers-MADS',
'BIGG-AZRXXX-AD',
'DNS-SelfService-MLOPS',
'ITSG-MLOpsAz-Admin',
'AKS-MLOPSV2-NP08-Admins',
'JDSG-AIFACTORY-ITS',
'GDSG-AzureDevOps-Users-DXC-MLOpsAz',
'GDSG-AzureDevOps-Users-Infosys-MLOpsAz',
'JDSG-Microsoft-AIFactory',
'GTOG-AKS-AIF-MT-Continuity-Plan',
'GTO-MLOpsAz-Operations',
'GTO-MLOpsAz-EPE',
'BIG-I-DTIXXX-AD',
'CDH-CoreDataPlatform-AzNonProdOwner',
'CDH-CoreDataPlatform-AzReader',
'CNF-Azure-All-users',
'IDHG-AirflowAdmins',
'IDHG-PlatformEngineers',
'ITSG-DAA-TEAM',
'GDSG-AzureDevops-User-PG-Airflow',
'GDSG-AzureDevops-User-DSStream-Airflow',
'GDS-AzureDevops-Airflow-ITS-DA',
'IDHG-AirflowPlatform-Admins',
'IDHG-LTI-AirflowPlatform-Support',
'IDH-AirflowPlatform-Admins',
'ITSG-AIF-AKS-MT-Prod-Admins',
'ITSG-AIF-AKS-MT-Test-Admins',
'ITSG-MLOpsAz-Operations',
'T1G-IDHG-PlatformTeam-ExtendedEPE',
'T1-CDH-CoreDataPlatform-AzReader',
'T1G-IDHG-PlatformEngineers',
'T1-CDH-CoreDataPlatform-AzNonProdOwner',
'T1G-GTO-MLOpsAz-Admin',
'T1G-GTO-MLOpsAz-Operations',
'T1G-GTO-AIF-AKS-MT-Prod-Admins',
'GDSG-AzureDevOps-Users-PG-GTO-CSE',
'GTOG-AIF-PBIGW-POC',
'T1-ITSG-MLOpsAz-Operations',
'T1-ITSG-AIF-AKS-MT-Prod-Admins',
'T1-ITSG-AIF-AKS-MT-Test-Admins',
'T1G-LTI-AirflowPlatform-Support',
'T1G-GTO-AIF-AKS-MT-Dev-Admins',
'T1G-GTO-AIF-AKS-MT-NonProd-Admins',
'T1-AzureOpenAIPlaygroud-DEV-Admin'
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
        $grId = (Get-AzADGroup -DisplayName $GroupName).Id
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


