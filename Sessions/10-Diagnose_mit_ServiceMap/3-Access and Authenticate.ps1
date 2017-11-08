# Create APPID/Key and paste values in the below variabled (MANUAL)
$Appid = '<Paste ID here>'
$AppKeyPlain = '<Paste Key here>'

#build body values
$Resource = "https://management.core.windows.net/"
$AppKey = $AppKeyPlain|ConvertTo-SecureString -AsPlainText -Force
$loginUrl = "https://login.microsoftonline.com"

$body = @{
    grant_type="client_credentials";
    resource=$Resource;
    client_id=$AppId;
    client_secret=(New-Object PSCredential $Appid,$AppKey).GetNetworkCredential().Password;
}

# Generate access token
$token = Invoke-RestMethod -Method Post -Uri $loginUrl/$TenantId/oauth2/token?api-version=1.0 -Body $body

   
