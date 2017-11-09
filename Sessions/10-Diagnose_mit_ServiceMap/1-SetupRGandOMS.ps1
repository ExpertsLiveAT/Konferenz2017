# Login with Profile (because my demo is based in private accoount)
#region Context creation with interactive login and "Save-Azurermcontext"
$login = Import-AzureRmContext "contextfile.json"

$subscriptionid = $login.context.Subscription.id
$tenantid = $login.Context.Tenant.Id

#Define Variables
$RG = 'NameOfRG'
$WS = 'NameOfLogAnalyticsWorkspace'
$Loc = 'westeurope'
$SKU = 'free'
#endregion

#region Create Resourcegroup and LogAnalytics Workspace
New-AzureRmResourceGroup -Name $RG -Location $Loc 
New-AzureRmOperationalInsightsWorkspace -ResourceGroupName $RG -Name $WS -Location $Loc -Sku $sku

#Add some basic solutions
$solutions = 'ServiceMap','WireData2','ChangeTracking'
foreach ($solution in $solutions)
    {Set-AzureRmOperationalInsightsIntelligencePack `
        -ResourceGroupName $RG `
        -WorkspaceName $WS `
        -IntelligencePackName $solution `
        -Enabled $true}
#endregion

#region Activate Performacecounters
New-AzureRmOperationalInsightsWindowsEventDataSource -ResourceGroupName $RG -WorkspaceName $WS -Name System -EventLogName System -CollectErrors -CollectInformation -CollectWarning
$Performancecounters = [ordered]@{
        LogicalDiskFS = "LogicalDisk-'% Free Space'";
      LogicalDiskADsR = "LogicalDisk-'Avg. Disk sec/Read'";
      LogicalDiskADsW = "LogicalDisk-'Avg. Disk sec/Write'";
      LogicalDiskCDQL = "LogicalDisk-'Current Disk Queue Length'";
       LogicalDiskDRs = "LogicalDisk-'Disk Reads/sec'";
       LogicalDiskDTs = "LogicalDisk-'Disk Transfers/sec'";
       LogicalDiskDWt = "LogicalDisk-'Disk Writes/sec'";
   LogicalDiskDFreeMB = "LogicalDisk-'Free Megabytes'";
           MemoryCBiU = "Memory-'% Committed Bytes In Use'";
         MemoryAbytes = "Memory-'Available MBytes'";
     NetworkAdapterBR = "'Network Adapter'-'Bytes Received/sec'";
     NetworkAdapterBs = "'Network Adapter'-'Bytes Sent/sec'";
  NetworkInterfaceBTs = "'Network Interface'-'Bytes Total/sec'";
          ProcessorPT = "'Processor'-'% Processor Time'";
            SystemPWL = "'System'-'Processor Queue Length'";
         }

$Performancecounters.Keys |foreach-object {
    $Name = $_
    $ObjectName = $Performancecounters[$_].split('-')[0]
    $CounterName = $Performancecounters[$_].split('-')[1]
    New-AzureRmOperationalInsightsWindowsPerformanceCounterDataSource `
    -ResourceGroupName $RG -WorkspaceName $WS `
    -Name $Name -Objectname $objectName -CounterName $Countername
}
#endregion
