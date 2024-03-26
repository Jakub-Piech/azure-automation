$subs = Get-AzSubscription
$allWorkspaces = @()
foreach ($sub in $subs) {
    set-azcontext -Subscription $sub.Name
    $workspaces = Get-AzDatabricksWorkspace
    foreach ($workspace in $workspaces) {
        $Object = New-Object PSObject
        $Object | Add-Member -MemberType NoteProperty -Name "WorkspaceId" -Value $workspace.WorkspaceId.ToString()
        $Object | Add-Member -MemberType NoteProperty -Name "WorkspaceName" -Value $workspace.Name.ToString()
        $Object
        $allWorkspaces += $Object
    }
}
$allWorkspaces | ConvertTo-CSV 
$allWorkspaces | Export-CSV -Path "./DBR_workspaces.csv" -NoTypeInformation | Out-String