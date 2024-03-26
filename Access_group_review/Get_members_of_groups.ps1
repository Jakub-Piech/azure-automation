<#

List RBACs that this group directly has

.EXAMPLE
# :by Group Name
$GroupNames = @(
'CSE-PlatformTeam-AzureAdmins-FHC',
'CSE-PlatformTeam-AzureAdmins-GBS',
'DNS-SelfService-AirflowPlatform',
'IDHG-All-AirflowPlatform-Admins',
'IDHG-DXC-AirFlow-Admins',
'IDH-AirflowAdmins',
'IDH-AirflowPlatform-Admins',
'IDHG-AirflowAdmins',
'IDHG-AirflowAdmins-POS',
'IDHG-AirflowPlatform-Admins',
'IDHG-LTI-AirflowPlatform-Support',
'CDH-CoreDataPlatform-DevOpsAgents-Admins',
'GDS-AzureDevops-Airflow-ITS-DA',
'GDSG-AzureDevops-User-DSStream-Airflow',
'GDSG-AzureDevops-User-DXC-Airflow',
'GDSG-AzureDevops-User-PG-Airflow',
'GSDG-AzureDevOps-Users-DXC-DataArchitecture',
'GDSG-AzureDevOps-Users-DXC-MLOpsAz',
'GDSG-AzureDevOps-Users-Infosys-MLOpsAz',
'GDSG-AzureDevOps-Developer-CoM-CapMan',
'ITSG-CSE-ADOUsers-MADS',
'GDSG-AzureDevOps-Users-PG-GTO-CSE',
'ITSG-AZURECSE-TEAM',
'IDHG-PlatformEngineers',
'ITSG-CSE-EmbeddedEngineers',
'IDHG-Admins',
'IDH-PlatformTeam-AzureAdminsBIG-I-DTIXXX-AD',
'BIGG-D-POSESEXXX-RD',
'CDH-CoreDataPlatform-AzNonProdOwner',
'CDH-CoreDataPlatform-AzReader',
'CDH-CoreDataPlatform-LaunchpadTagUpdate',
'CNF-Azure-All-users',
'CNFG-TEST-Michal',
'GSDG-SynapseTestingApp-Admin-Group',
'ITS-CSE-PowerUser',
'ITSG-AIF-AKS-MT-Prod-Admins',
'ITSG-AIF-AKS-MT-Test-Admins',
'ITSG-DAA-TEAM',
'ITSG-MLOpsAz-Operations',
'AKS-MLOPSV2-NP08-Admins',
'BIGG-AZRXXX-AD',
'DNS-SelfService-MLOPS',
'ITSG-MLOpsAz-Admin',
'JDSG-AIFACTORY-ITS',
'JDSG-Microsoft-AIFactory',
'CNFG-TEST_MichalK',
'ITSG-PenTest-Admins',
'ITSG-PenTest-Users',
'DNS-SelfService-AZ-AA-PORTAL',
'ITS-FeedbackOptimize',
'ITSG-SophieCSE-PG',
'ITSG-SophieCSE-Ext',
'ITS-SophieCSE',
'ITS-Sophie-Users',
'GITG-askPG-Cloud-admins',
'GITG-askPG-Cloud-users',
'T1-CSE-PlatformTeam-AzureAdmins-FHC',
'T1-CSE-PlatformTeam-AzureAdmins-GBS',
'T1-CDH-CoreDataPlatform-AzNonProdOwner',
'T1-IDH-PlatformTeam-AzureAdmins',
'T1-CDH-CoreDataPlatform-AzReader',
'T1G-IDHG-PlatformEngineers'
'T1-ITS-DAAzurePlatform-Approvers',
'T1G-IDHG-PlatformTeam-ExtendedEPE',
'T1G-IDHG-PlatformTeam-ExtendedEPE'
)
Temp/Access_group_review/Get_members_of_groups.ps1 -i $GroupNames

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
    $GroupMembers | Export-Csv -Path "Temp/Access_group_review/Get_members_of_groups_$date.csv"
}


