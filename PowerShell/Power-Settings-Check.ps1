#This PowerShell script checks for the "High performance" power scheme on a Windows system, creates it if it does not exist, and sets the display and disk idle timeouts to "Never". It also validates the settings after applying them.#

# Step 1: Check for "High performance" power scheme
$powerScheme = powercfg /l | Select-String -Pattern "High performance" | ForEach-Object {
    $_.ToString().Split()[3]
}

# Step 2: Create the scheme if not found
if (-not $powerScheme) {
    Write-Output "High performance power scheme not found. Creating it..."
    $newSchemeName = "High performance"
    $guid = [guid]::NewGuid().ToString()
    powercfg /duplicatescheme SCHEME_MIN $guid
    powercfg /changename $guid "$newSchemeName"
    $powerScheme = $guid
}

# Step 3: Activate the scheme
Write-Output "Activating High performance power scheme: $powerScheme"
powercfg /setactive $powerScheme

# Step 4: Disable display and disk idle timeouts
$powerSettings = @(
    @{ SubGroup = "SUB_VIDEO"; Setting = "VIDEOIDLE"; Description = "Turn off display after" },
    @{ SubGroup = "SUB_DISK"; Setting = "DISKIDLE"; Description = "Turn off hard disk after" }
)

foreach ($setting in $powerSettings) {
    Write-Output "Disabling timeout for: $($setting.Description)"
    powercfg /setacvalueindex $powerScheme $($setting.SubGroup) $($setting.Setting) 0
    powercfg /setdcvalueindex $powerScheme $($setting.SubGroup) $($setting.Setting) 0
}

# Apply the changes
powercfg /S $powerScheme

# Step 5: Validate the settings
Write-Output "Validating settings..."
foreach ($setting in $powerSettings) {
    $acValue = powercfg /q $powerScheme $($setting.SubGroup) $($setting.Setting) | Select-String "Current AC Power Setting Index" | ForEach-Object {
        ($_ -split ":")[1].Trim()
    }
    $dcValue = powercfg /q $powerScheme $($setting.SubGroup) $($setting.Setting) | Select-String "Current DC Power Setting Index" | ForEach-Object {
        ($_ -split ":")[1].Trim()
    }

    if ($acValue -eq "0" -and $dcValue -eq "0") {
        Write-Output "$($setting.Description): AC and DC values set to 0 (Never)"
    } else {
        Write-Output "$($setting.Description): Validation failed - AC: $acValue, DC: $dcValue" 
        exit 1
    }
} Write-Output "Power scheme and settings updated and validated."
# End logging


# End of PowerSettingsCheck.ps1