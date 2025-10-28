# ------------------- Variables -------------------
$file = "C:\LCE\VirtualMachines\cvng-server.iso"
$azureBaseURL = "URL"
$azureBaseSAS = "SAS"
$downloadDestination = "C:\VirtualMachines\cvng-server.iso"
$hash = "04B01E4D527287F489E5DF4B0B1338A07D7AD57A34F4FA0CF80B115F0205FE42"
$filehash = (Get-FileHash C:\VirtualMachines\cvng-server.iso -algorithm sha256).Hash
$jobs = Get-BitsTransfer
$VHDServerFile = "C:\VirtualMachines\cvngserver.vhdx"
$VHDServerFolder = "C:\VirtualMachines\cvng-server-virt"
$VM = "cvng-server-virt"

#--------------------Main Script------------------
Start-Transcript -Path c:\Logs\HV-Phase2.log -force -Verbose
New-Item -ItemType Directory -Path C:\VirtualMachines
Write-Host "Checking if there was a previous download of the CVNG server attempted"
# Check if there is an active BITS jobs for CVNG Server ISO

foreach ($job in $jobs) {
    while ( ($job.JobState.ToString() -eq 'Transferring') -or ($job.JobState.ToString() -eq 'Connecting') )
    {
        if ($job.BytesTotal - $job.BytesTransferred -gt 0) {
            # Completion calculations
            $percentComplete = [int](($job.BytesTransferred * 100) / $job.BytesTotal)
            $gbTransferred = [math]::round(($job.BytesTransferred / 1000000000), 2)
            $gbTotal = [math]::round(($job.BytesTotal / 1000000000), 2)
            
            # Speed / time remaining calculations
            $bytesAdded = $job.BytesTransferred - $previousByteCount
			$bytesRemaining = $job.BytesTotal - $job.BytesTransferred
            $downloadSpeed = [math]::round(($bytesAdded / 1000000), 2)
            $downloadSecondsRemaining = $bytesRemaining / $bytesAdded
            $downloadTimeRemaining = New-TimeSpan -Seconds $downloadSecondsRemaining

            Write-Progress -Activity "Downloading $($image.Name).iso" -PercentComplete $percentComplete -CurrentOperation "File: $gbTransferred GB/$gbTotal GB; Speed: $downloadSpeed MB/s; Time Remaining: $($downloadTimeRemaining.Hours) hr $($downloadTimeRemaining.Minutes) min $($downloadTimeRemaining.Seconds) sec"
            $previousByteCount = $job.BytesTransferred
            Start-Sleep -Seconds 1

            # Check if the transfer is stuck (transient error)
            if ($job.JobState -contains "TransientError") {
                Get-BitsTransfer -all | Resume-BitsTransfer -Asynchronous
            }
        }
    }
    Complete-BitsTransfer -BitsJob $job
}

# Checking if ISO is present
function file-check 
{
    $check = Get-ChildItem -Path $file
    if ($check -ne $null)
    {
    $send = $true
    }
    else
    {$send = $false}
   return $send
}
#Checking Hash of found ISO to see if it matches the needed version
function hash-check
{
    if ($fileHash -eq $hash)
    {
    $send = $true
    }
    else
    {$send = $false}
   return $send
}

if (!(file-check)){ $needdownload = $true }
if ((file-check) -and (!(hash-check))) 
{Remove-Item -Path $file -Force
	$needdownload = $true}
if ($needdownload){
do {

Write-Host "Downloading latest CV Server ISO from Azure. This may take a few minutes."

    # Start download job for given image 
    Write-Host "Info: Starting download job for $($image.Name)"
    $job = Start-BitsTransfer -Source ($azureBaseURL   + $azureBaseSAS) -Destination ($downloadDestination) -Asynchronous
    if (!($?)) {
        Write-Host "Warning: Failed to start file transfer job. Exiting..."
        Stop-Transcript
        exit 1
    }
    
    # Wait initial amount of time for job to start or throw an error
    Start-Sleep -Seconds 5
    if ($job.JobState.ToString() -eq 'Error') {
        Write-Host "Warning: Failed to transfer $($image.Name)"
    }

    $previousByteCount = 1
    while ( ($job.JobState.ToString() -eq 'Transferring') -or ($job.JobState.ToString() -eq 'Connecting') )
    {
        if ($job.BytesTransferred - $previousByteCount -gt 0) {
            # Completion calculations
            $percentComplete = [int](($job.BytesTransferred * 100) / $job.BytesTotal)
            $gbTransferred = [math]::round(($job.BytesTransferred / 1000000000), 2)
            $gbTotal = [math]::round(($job.BytesTotal / 1000000000), 2)
            
            # Speed / time remaining calculations
            $bytesAdded = $job.BytesTransferred - $previousByteCount
            $bytesRemaining = $job.BytesTotal - $job.BytesTransferred
            $downloadSpeed = [math]::round(($bytesAdded / 1000000), 2)
            $downloadSecondsRemaining = $bytesRemaining / $bytesAdded
            $downloadTimeRemaining = New-TimeSpan -Seconds $downloadSecondsRemaining

            Write-Progress -Activity "Downloading $($image.Name).iso" -PercentComplete $percentComplete -CurrentOperation "File: $gbTransferred GB/$gbTotal GB; Speed: $downloadSpeed MB/s; Time Remaining: $($downloadTimeRemaining.Hours) hr $($downloadTimeRemaining.Minutes) min $($downloadTimeRemaining.Seconds) sec"
            $previousByteCount = $job.BytesTransferred
            Start-Sleep -Seconds 1

            # Check if the transfer is stuck (transient error)
            if ($job.JobState -contains "TransientError") {
                Get-BitsTransfer -all | Resume-BitsTransfer -Asynchronous
            }
        }
    }
    Complete-BitsTransfer -BitsJob $job


$count++ 
} until (($count -eq 5) -or (file-check -eq $true) )

if ($count -eq 5)
{
    #failed to download file
    write-host "CV Server ISO download failed please check internet and rerun script."
    exit
}
}


# Removing cvngserver.vhdx  file and removing the cvng-server-virt folder and all data inside it.

Write-Host "Removing old virtual server files and folders"
Stop-VM -Name "$VM" -Force
Remove-VM "$VM" -Force
Remove-Item -Path $VHDServerFile -Force
Remove-Item -Path $VHDServerFolder -Force -Recurse

Write-Host "Creating Virtual CV Server"
# Creating Switch for cvngserver virtual machine
New-VMSwitch -Name "LAN" -NetAdapterName Ethernet -AllowManagementOS:$true
# Creating the cvngserver virtual machine
New-VM -Name cvng-server-virt -MemoryStartupBytes 24GB -BootDevice VHD -NewVHDPath C:\VirtualMachines\cvngserver.vhdx -Path C:\VirtualMachines -NewVHDSizeBytes 250GB -Generation 2 -Switch LAN

Add-VMDvdDrive -VMName cvng-server-virt -Path C:\VirtualMachines\cvng-server.iso

Set-VMMemory cvng-server-virt -DynamicMemoryEnabled $false

$dvd = Get-VMDvdDrive -VMName cvng-server-virt

Set-VMFirmware -VMName cvng-server-virt -FirstBootDevice $dvd

Set-VMProcessor cvng-server-virt -Count 6

Set-VMFirmware -VMName cvng-server-virt -EnableSecureBoot off

Start-VM -Name cvng-server-virt

Connect-VM cvng-server-virt
