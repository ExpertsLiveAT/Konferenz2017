#region Authenticate and get token
$Resource = "https://management.core.windows.net/"
$AppKey = $AppKeyPlain|ConvertTo-SecureString -AsPlainText -Force
$loginUrl = "https://login.microsoftonline.com"

$body = @{
    grant_type="client_credentials";
    resource=$Resource;
    client_id=$AppId;
    client_secret=(New-Object PSCredential $Appid,$AppKey).GetNetworkCredential().Password;
}
$token = Invoke-RestMethod -Method Post -Uri $loginUrl/$TenantId/oauth2/token?api-version=1.0 -Body $body
#endregion

#region Get Machine internal Name

# Get machine internal Name
$SMurl = "https://management.azure.com/subscriptions/$($SubscriptionId)/resourceGroups/$($RG)/providers/Microsoft.OperationalInsights/workspaces/$($WS)/features/serviceMap/machines?api-version=2015-11-01-preview"
$body = @{
    ts = [System.DateTime]::UtcNow.ToString('o')
}
$header = @{
    'Authorization' = "$($Token.token_type) $($Token.access_token)"
    "Content-Type" = "application/json"
}
$SMMachines = Invoke-RestMethod `
    -Method Get `
    -Uri $SMurl `
    -ContentType application/json `
    -Headers $header `
    -Body $body

$MachineResourceName = $SMMachines.value.name
#endregion

#region Get processes of cressida
$SMurl = "https://management.azure.com/subscriptions/$($SubscriptionId)/resourceGroups/$($RG)/providers/Microsoft.OperationalInsights/workspaces/$($WS)/features/serviceMap/machines/$($MachineResourceName)/processes?api-version=2015-11-01-preview"
$body = @{
    ts = [System.DateTime]::UtcNow.ToString('o')
}
$header = @{
    'Authorization' = "$($Token.token_type) $($Token.access_token)"
    "Content-Type" = "application/json"
}
$SMMachineProcesses = Invoke-RestMethod `
    -Method Get `
    -Uri $SMurl `
    -ContentType application/json `
    -Headers $header `
    -Body $body

$ProcessCount = ($SMMachineProcesses.value.properties.displayName).count
#endregion

#region Map Azure FileShare to A: and check CSV File existence
          
$sa = Get-AzureRmStorageAccount -ResourceGroupName $RG -Name $SaParam.Name

#Get Storage Account Access Key
$SAKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $RG -Name $SA.StorageaccountName).Value[0]

$fsparam = @{name = 'fs1';
context = $sa.Context}
$fs = get-AzureStorageShare  @fsparam

# Map share and check existence of CSV Data file / reate one
$fsKey = ConvertTo-SecureString -String $saKey -AsPlainText -Force
$fsCred = New-Object System.Management.Automation.PSCredential -ArgumentList "Azure\$($sa.StorageAccountName)", $fsKey

if (!(Get-Psdrive -Name A -ErrorAction SilentlyContinue)) {
New-PSDrive -Name A -PSProvider FileSystem -Root "\\$($sa.StorageAccountName).file.core.windows.net\$($fs.Name)" -Credential $fscred #-Persist
}

#wait for ps drive creation
start-sleep 2
# If not present, create empty CSV File
if (!(Test-Path -Path 'A:\ServiceMapdata.csv')) {
$csvHeader = @"
"Timestamp","DisplayName","NumberOfProcesses"
"@
$csvHeader >A:\Servicemapdata.csv
}
#endregion

#region Write ServiceMap Data to the CSV File
[String]$Timestamp = Get-Date
[String]$DisplayName = $SMMachines.value.properties.DisplayName
$Datarecord = @"
"$timestamp","$DisplayName","$processcount"
"@

#Write actual record to datafile
add-Content -path 'A:\Servicemapdata.csv' -Value $Datarecord -Encoding UTF8
#endregion
