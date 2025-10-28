### This script sets the ScreenConnect Client GUID of a client computer
### to a unique value based off a hash of the CWID variable created in this script

## Look at the ScreenConnect service name on computer & stop the service.
$serverid = "c3f7c29890f10967"
Stop-Service -displayname "ScreenConnect Client ($serverid)"

## Find current GUID to replace
$rpath = "HKLM:\SYSTEM\CurrentControlSet\Services\ScreenConnect Client ($serverid)"
$ipath = (Get-ItemProperty -path $rpath).ImagePath
$replaceguid = $ipath.Substring(($ipath.IndexOf("&s="))+3,36)

## Generate a system environment variable called CWID and then change GUID value based off hash of CWID value. Requires env system variable in order for hash conversion to work. 
$CWID = -join ((48..57) + (97..122) | Get-Random -Count 16 | % {[char]$_})
New-Item -Path Env:\CWGUID -Value $CWID
$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$utf8 = New-Object -TypeName System.Text.UTF8Encoding
$hash = [System.BitConverter]::ToString($md5.ComputeHash($utf8.GetBytes($env:CWGUID)))
[GUID]$guid = $hash.replace("-","")

## Change GUID in ImagePath in registry
Set-ItemProperty -path $rpath -name ImagePath -type String -value $($ipath -replace $("s=" + $replaceguid),$("s="+$guid.ToString()))

##Start ScreenConnect Service
Start-Service -displayname "ScreenConnect Client ($serverid)"