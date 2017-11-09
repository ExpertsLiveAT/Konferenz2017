#region Create Storage Account
# Define parameters in Hashtable
$SaParam = @{ResourceGroupName = $RG;
                          Name = '<Enter a storage account Name here>';
                       SkuName = 'Standard_LRS';
                          Kind = 'Storage';
                      Location = $Loc;
                }
#Create Storage account
$sa = New-AzureRmStorageAccount @Saparam
#Get Access key
$SAKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $RG -Name $SA.StorageaccountName).Value[0]

#endregion

#region Create Fileshare "FS1"
$fsparam = @{name = 'fs1';
            context = $sa.Context}
$fs = New-AzureStorageShare  @fsparam
#endregion

#region Mapp the share to the local machine (port 445 must be open to Azure)
# first we create a credential object to be able to acess the share
$fsKey = ConvertTo-SecureString -String $saKey -AsPlainText -Force
$fsCred = New-Object System.Management.Automation.PSCredential -ArgumentList "Azure\$($sa.StorageAccountName)", $fsKey

# Now we map the share with the credentials
New-PSDrive -Name A -PSProvider FileSystem -Root "\\$($sa.StorageAccountName).file.core.windows.net\$($fs.Name)" -Credential $fscred #-Persist

#endregion

#Create a Testfile
"ELAT ist cool" >> "a:\filefortesting.txt"

# If you want to map the share from another application ose the rsults of command below.
"\\$($sa.StorageAccountName).file.core.windows.net\$($fs.Name)"|clip
$fscred.UserName|clip
$sakey|clip



