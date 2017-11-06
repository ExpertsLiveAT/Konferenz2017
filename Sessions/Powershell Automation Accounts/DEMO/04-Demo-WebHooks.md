# WebHooks

## Anlegen von Webhooks
Im [Azure Portal](https://portal.azure.com "Azure Portal Seite") über den entsprechenden Automation Account das Runbook auswählen. In den Optionen des Runbooks den Puntk 'Add WebHook' auswählen und dort einen Namen definieren sowie ob er aktiviert ist und wann der Webhook abläuft.

![Screenshot Webhook anlegen]

in den Parametern können anschließend für diesen WebHook Parameter angegeben werden die als Input für das Runbook gelten. Damit ist es möglich mehrere Webhooks mit unterschiedlichen Parametersets zu bauen. Damit muss (bzw. kann) der Aufruf des WebHooks keine Parameter mitgeben.

![Screenshot Webhook parameter und run settings]

## Parameter und Webhooks

Im zweiten Schitt ist es aber auch möglich die Parameter für einen WebHook nicht fest am Hook zu definieren, sondern dynamisch per POST auf den WebHook mitzugeben.

```Powershell
Param
([object]$WebhookData) #this parameter name needs to be called WebHookData otherwise the webhook does not work as expected.
$VerbosePreference = 'continue'

# If runbook was called from Webhook, WebhookData will not be null.
if ($WebhookData)
{
  # Collect properties of WebhookData
  $WebhookName     = $WebhookData.WebhookName
  $WebhookHeaders  = $WebhookData.RequestHeader
  $WebhookBody     = $WebhookData.RequestBody

  # Collect individual headers. Input converted from JSON.
  $From = $WebhookHeaders.From
  $Input = (ConvertFrom-Json -InputObject $WebhookBody)
  Write-Verbose -Message "WebhookBody: $Input"
  Write-Output -InputObject ('Runbook started from webhook {0} by {1}.' -f $WebhookName, $From)
}
else
{
  Write-Error -Message 'Runbook was not started from Webhook' -ErrorAction stop
}
```

Der Aufruf des Webhooks kann ganz einfach per Powershell passieren oder mit jedem bevorzugten Tool (Curl, Postman, ...)

```Powershell
$webhookurl = 'https://s2events.azure-automation.net/webhooks?token=<token>'

$body = @{'LastName' = 'Wilfing'; 'FirstName' = 'Christoph';'VMName' = $(Read-Host -Prompt 'Which VM to Start?')}

Invoke-RestMethod -Method Post `
                  -Uri $webhookurl `
                  -ContentType 'application/json' `
                  -Headers @{'from' = 'Christoph Wilfing'; 'Date' = "$(Get-Date)"} `
                  -Body $($body | ConvertTo-Json) `
                  -Verbose
```

## Webhooks und Alerts

[Azure Metric Alerts](https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/insights-webhooks-alerts) erlauben es immer über Post Events auch Webhooks aufzurufen. Dabei wird auf Basis des Alerts (High CPU, Low Memory,...) ein Webhook aufgerufen der ein entsprechendes JSON File an den Webhook postet. Dieser Webhook kann anschließend die Daten auswerten und darauf entsprechend reagieren.

![Screenshot Azure Alert]


[Screenshot Webhook anlegen]: ../Pictures/Demo-Create-a-Webhook.png "Webhook anlegen"
[Screenshot Webhook parameter und run settings]: ../Pictures/Demo-Create-a-Webhook_1.png "Webhook anlegen - parameter und run settings"
[Screenshot Azure Alert]: ../Pictures/Demo-Azure-Alert-WebHook.png "Azure Alert anlegen"