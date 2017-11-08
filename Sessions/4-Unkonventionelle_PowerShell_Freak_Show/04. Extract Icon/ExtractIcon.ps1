# some paths
$IconPath = "C:\Users\stefankoell\Dropbox\Experts Live Europe\PowerShell\04. Extract Icon\Icon\ApplicationIcon.ico"
$OutputPath = "C:\Users\stefankoell\Dropbox\Experts Live Europe\PowerShell\04. Extract Icon\PNGs\"

# first we need a file stream
$iconStream = New-Object System.IO.FileStream $IconPath, "Open"

# create a "IconBitmapDecoder" class instance
$decoder = New-Object System.Windows.Media.Imaging.IconBitmapDecoder $iconStream, ([System.Windows.Media.Imaging.BitmapCreateOptions]::PreservePixelFormat), ([System.Windows.Media.Imaging.BitmapCacheOption]::None)

# go through all the frames
Foreach ($frame in $decoder.Frames) {
    
    # grab the bitmap frame
    $bitmapFrame = [System.Windows.Media.Imaging.BitmapFrame]$frame
    
    # read the size of the frame
    $size = $bitmapFrame.PixelHeight;

    Write-Host Processing Size: $size -ForegroundColor DarkCyan
    
    # set destination path for frame
    $destinationPath = [System.IO.Path]::Combine($OutputPath, "ApplicationIcon") + "_" + $size + "x" + $size + ".png"
    
    # create a PNG
    $encoder = New-Object System.Windows.Media.Imaging.PngBitmapEncoder
    
    # use the encoder to add the one PNG frame
    ([System.Collections.IList]$encoder.Frames).Add($frame)
    
    # create a file stream
    $saveStream = New-Object System.IO.FileStream $destinationPath, "Create"
    
    # use the encoder to save the stream to the file system
    $encoder.Save($saveStream)
    
    Write-Host Saving file: $destinationPath -ForegroundColor DarkGreen
    
    # cleanup the encoder stream
    $saveStream.Close()
    $saveStream.Dispose()

}

# cleanup the icon stream
$iconStream.Close()
$iconStream.Dispose()
