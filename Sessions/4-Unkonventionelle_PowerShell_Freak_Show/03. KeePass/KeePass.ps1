# source code can be found here:
# https://sourceforge.net/projects/keepass/files/KeePass%202.x/

# set exe, file path and password
$KeePassPath = "C:\Users\StefanKoell\Dropbox\Experts Live Europe\PowerShell\03. KeePass\KeePass\KeePass.exe"
$KeePassFile = "C:\Users\stefankoell\Dropbox\Experts Live Europe\PowerShell\03. KeePass\Existing.kdbx"
$Password = "test"

# load the KeePass.exe into PowerShell
[Reflection.Assembly]::LoadFile($KeePassPath)

# create objects to open a database
$Kdbx = New-Object KeePassLib.PwDatabase
$Key = New-Object KeePassLib.Keys.CompositeKey
$Key.AddUserKey((New-Object KeePassLib.Keys.KcpPassword($Password)))

$File = New-Object KeePassLib.Serialization.IOConnectionInfo
$File.Path = $KeePassFile

$Logger = New-Object KeePassLib.Interfaces.NullStatusLogger

# open the database
$Kdbx.Open($File, $Key, $Logger)

# get all items from the root group
$Items = $Kdbx.RootGroup.GetObjects($true, $true)

# iterate through all items
foreach ($Item in $Items)
{
    Write-Host "Item Title:    " $Item.Strings.ReadSafe("Title")
    Write-Host "Item Username: " $Item.Strings.ReadSafe("UserName")
    Write-Host "Item Password: " $Item.Strings.ReadSafe("Password")
    Write-Host
}

