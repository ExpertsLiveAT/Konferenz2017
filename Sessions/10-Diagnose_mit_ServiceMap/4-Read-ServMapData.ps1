# Define Query URL´s.
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
$SMMachines

# Sample to get some data:
$SMMachines.value.properties

# More at: https://docs.microsoft.com/en-us/rest/api/servicemap/

