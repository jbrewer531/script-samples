# Function to get IP details
function Get-IPInfo {
    param (
        [string]$ip
    )
    $url = "http://ip-api.com/json/$ip"
    $response = Invoke-RestMethod -Uri $url
    return $response
}

# Prompt user for IP address
$ip = Read-Host "Enter an IP address"
Write-Host "Fetching information for IP: $ip..."
$data = Get-IPInfo -ip $ip

if ($data.status -eq "fail") {
    Write-Host "Error: Unable to retrieve data. Check if the IP is valid."
} else {
    Write-Host "IP Information Retrieved:"
    Write-Host "---------------------------------"
    Write-Host "IP: $data"
    
}
