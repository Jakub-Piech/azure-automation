# this scripts gives path of nested groups to understand how is user/group a member of a certain group (max 2 groups down from the one searched for)
# issue type 'Resource 'a5d706de-ebb6-4d5f-8bf6-a3914ca66e76' does not exist or one of its queried reference-property objects are not present.' is ok as this is to user accounts



[CmdletBinding()]
Param(	
	[Parameter(Mandatory=$true,Position=1)] [string] $GroupId,
	[Parameter(Mandatory=$True,Position=2)] [string] $UserId
)
  
$GetGroupName = Get-AzADGroup -ObjectId $GroupId
$GroupName=$GetGroupName.DisplayName
$Groups = Get-AzADGroup -ObjectId $GroupId | Get-AzADGroupMember # get full list of group members

foreach ($Group in $Groups) {
    if (($Group.OdataType -eq '#microsoft.graph.user') -and ($Group.Id -eq $UserId)) #checking for users (not groups)
    {
       Write-Host "User is directly assigned in searched group"
        exit
    }
}

$allGroups= @() 

foreach ($Group in $Groups) {
    if($Group.OdataType -eq '#microsoft.graph.group'){
        $Groups2 = Get-AzADGroup -ObjectId $Group.Id | Get-AzADGroupMember 
        foreach ($Group2 in $Groups2) { 
                if (($Group2.OdataType -eq '#microsoft.graph.user') -and ($Group2.Id -eq $UserId))
                {
                   $Object = New-Object PSObject
                   $Object | Add-Member -MemberType NoteProperty -Name "User Id" -Value $UserId
                   $Object | Add-Member -MemberType NoteProperty -Name "Searched Group Id" -Value $GroupId
                   $Object | Add-Member -MemberType NoteProperty -Name "Searched Group Name" -Value $GroupName
                   $Object | Add-Member -MemberType NoteProperty -Name "Nested Group Id" -Value $Group.Id
                   $Object | Add-Member -MemberType NoteProperty -Name "Nested Group Name" -Value $Group.DisplayName
                   $allGroups += $Object
                }
                ELSE{
                if ($Group2.OdataType -eq '#microsoft.graph.group'){
                $Groups3 = Get-AzADGroup -ObjectId $Group2.Id | Get-AzADGroupMember 
                foreach ($Group3 in $Groups3) { 

                        if (($Group3.OdataType -eq '#microsoft.graph.user') -and ($Group3.Id -eq $UserId))
                        {
                            $Object = New-Object PSObject
                            $Object | Add-Member -MemberType NoteProperty -Name "User Id" -Value $UserId
                            $Object | Add-Member -MemberType NoteProperty -Name "Searched Group Id" -Value $GroupId
                            $Object | Add-Member -MemberType NoteProperty -Name "Searched Group Name" -Value $GroupName
                            $Object | Add-Member -MemberType NoteProperty -Name "Nested Group Id" -Value $Group.Id
                            $Object | Add-Member -MemberType NoteProperty -Name "Nested Group Name" -Value $Group.DisplayName
                            $Object | Add-Member -MemberType NoteProperty -Name "2.Nested Group Id" -Value $Group2.Id
                            $Object | Add-Member -MemberType NoteProperty -Name "2.Nested Group Name" -Value $Group2.DisplayName
                            $allGroups += $Object
                        }
                        }
                    }
                }
            }
        }
    }

$allGroups
 # $allGroups| Export-Csv -Path "C:\Users\piech.j\OneDrive - Procter and Gamble\Desktop\GroupAssignment.csv"