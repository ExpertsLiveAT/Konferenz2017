# oleview.exe: "C:\Program Files (x86)\Windows Kits\10\bin\10.0.15063.0\x64\oleview.exe"

# set image path
$path = "C:\Users\stefankoell\Dropbox\Experts Live Europe\PowerShell\05. Fun with COM\Images\"

# create an instance of the InternetExplorer Application
$ie = New-Object -ComObject InternetExplorer.Application

# explore members
$ie | Get-Member

# make it visible - can also be invisible. ActiveX cannot be invisible
$ie.visible = $true

# navigate to an url
$ie.Navigate('https://royalapplications.com')

# note: this may take a while. check document completed event or check $ie.Busy property

# go through all images
foreach ($image in $ie.Document.images)
{
    # download image and save it to disk
    $fileName = $image.nameProp
    Invoke-WebRequest -Uri $image.src -OutFile "$path$fileName"
}

# don't forget to quit and release the com object, especially when using in hidden mode
$ie.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($ie)