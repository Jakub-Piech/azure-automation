<#

List RBACs that this group directly has

.EXAMPLE
# :by Group Name
$GroupNames = @(
'DNS-SelfService-AirflowPlatform',
'T1G-LTI-AirflowPlatform-Support',
'T1G-IDHG-PlatformTeam-ExtendedEPE',
'T1G-IDHG-PlatformEngineers',
'T1G-GTO-MLOpsAz-Operations',
'T1G-GTO-MLOpsAz-Admin',
'T1G-GTO-AIF-AKS-MT-Prod-Admins',
'IDHG-PlatformEngineers',
'IDHG-LTI-AirflowPlatform-Support',
'IDHG-AirflowPlatform-Admins',
'IDHG-AirflowAdmins',
'GDSG-AzureDevops-User-PG-Airflow',
'GDSG-AzureDevops-User-DSStream-Airflow',
'GDS-AzureDevops-Airflow-ITS-DA',
'ITSG-CSE-EmbeddedEngineers',
'GTOG-VICA-ADMINS',
'GITG-askPG-Cloud-users',
'GITG-askPG-Cloud-admins',
'T1G-GTO-AIF-AKS-MT-NonProd-Admins',
'T1G-GTO-AIF-AKS-MT-Dev-Admins',
'JDSG-Microsoft-AIFactory',
'JDSG-AIFACTORY-ITS',
'ITSG-MLOpsAz-Admin',
'GTO-MLOpsAz-Operations',
'GTO-MLOpsAz-EPE',
'GTOG-AKS-AIF-MT-Continuity-Plan',
'DNS-SelfService-MLOPS',
'GTOG-AIF-PBIGW-POC',
'GDSG-AzureDevOps-Users-PG-GTO-CSE',
'T1-AzureOpenAIPlaygroud-DEV-Admin',
'ITSG-DAA-TEAM',
'T1-CDH-CoreDataPlatform-AzReader',
'IDH-AirflowPlatform-Admins',
'ITSG-MLOpsAz-Operations',
'ITSG-AIF-AKS-MT-Test-Admins',
'ITSG-AIF-AKS-MT-Prod-Admins',
'AKS-MLOPSV2-NP08-Admins',
'IDHG-PlatformTeam-ExtendedEPE',
'T1-CDH-CoreDataPlatform-AzNonProdOwner',
'CDH-CoreDataPlatform-AzNonProdOwner',
'IDHG-DXC-AirFlow-Admins',
'IDHG-All-AirflowPlatform-Admins',
'T1-ITSG-MLOpsAz-Operations',
'T1-ITSG-AIF-AKS-MT-Test-Admins',
'T1-ITSG-AIF-AKS-MT-Prod-Admins',
'BIGG-AZRXXX-AD'
)
Access_group_review/Get_members_of_groups.ps1 -i $GroupNames

#>
[CmdletBinding(DefaultParametersetName = 'default')]
param (
    [Alias('i')]
    [Parameter(Mandatory, ParameterSetName = 'ByName')]
    [System.Object]$GroupNames
)

process {
    $GroupMembers= @()

    foreach ($GroupName in $GroupNames) {
        $Groups2 = Get-AzADGroup -DisplayName $GroupName | Get-AzADGroupMember 
        foreach ($Group2 in $Groups2) { 
            if (($Group2.OdataType -eq '#microsoft.graph.user'))
            {
                $type = "User"
            }
            ELSE{
                $type = "Group"
            }
            $mail = (Get-AzADGroup -DisplayName $GroupName).MailEnabled
            $Object = New-Object PSObject
            $Object | Add-Member -MemberType NoteProperty -Name "Searched Group Name" -Value $GroupName
            $Object | Add-Member -MemberType NoteProperty -Name "Searched Group Mail Enabled?" -Value $mail
            $Object | Add-Member -MemberType NoteProperty -Name "Member Id" -Value $Group2.Id
            $Object | Add-Member -MemberType NoteProperty -Name "Member Name" -Value $Group2.DisplayName
            $Object | Add-Member -MemberType NoteProperty -Name "Member Type" -Value $type
            $GroupMembers += $Object
        }
    }
}

end{
    $date = Get-Date -Format "dd_MM_yyyy"
    $GroupMembers | Export-Csv -Path "Access_group_review/Get_members_of_groups_$date.csv"
}


