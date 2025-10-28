# Define the registry keys and value names
$registryChecks = @(
    @{ Path = "HKLM:\SYSTEM\CurrentControlSet\Services\WcmSvc"; Name = "DependOnService" },
    @{ Path = "HKLM:\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxySvc"; Name = "Start" }
)

# Loop through each registry item and get the value
foreach ($check in $registryChecks) {
    try {
        $value = Get-ItemPropertyValue -Path $check.Path -Name $check.Name -ErrorAction Stop
        if ($value -is [array]) {
            Write-Output "[$($check.Path)] $($check.Name): $($value -join ', ')"
        } else {
            Write-Output "[$($check.Path)] $($check.Name): $value"
			pause
        }
    } catch {
        Write-Output "[$($check.Path)] $($check.Name): Not Found or Access Denied"
    }
}
