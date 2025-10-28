[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$url = "URL"
$cwbfile = "C:\test\Programs\ConnectWise\ConnectWiseBackup1.msi"

Invoke-WebRequest -Uri $url -OutFile $cwbfile

if (Test-Path $cwbfile) {
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/I $cwbfile /qn" -Wait
    Remove-Item -Path 'C:\test\Programs\ConnectWise' -Recurse -Force
} else {
    Write-Host "Download failed or file not found!"
}