# Find Workspace ID and store in variable
$wsid = Get-AzureRmOperationalInsightsWorkspace -ResourceGroupName $rg|Select-Object CustomerId

# Get WS ID and copy to Clipboard
$wsid.CustomerId.Guid|clip

# Get Loganalytics WS Keys
$keys = Invoke-AzureRmResourceAction -ResourceGroupName $RG -ResourceType Microsoft.OperationalInsights/workspaces -ResourceName $WS -Action sharedKeys  -ApiVersion 2015-11-01-preview -Force
$keys.primarySharedKey|clip

#Run this as local admin !
$mma = New-object -ComObject 'AgentConfigManager.MgmtSvcCfg'
$mma.AddCloudWorkspace($wsid.CustomerId.Guid, $keys.primarySharedKey)
$mma.ReloadConfiguration()

<#
# or copy ID/Key to this comand and run as admin
$mma = New-object -ComObject 'AgentConfigManager.MgmtSvcCfg'
$mma.AddCloudWorkspace('', '')
$mma.ReloadConfiguration()
#>