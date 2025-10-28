#######Choco Installs
$baseURI = "URL"
$sasToken = "SAS"

$Choco_App_version = $baseURI + $blobPath + $sasToken    
Invoke-WebRequest -Uri $Phone_App_version -UseBasicParsing -OutFile C:\scripts\branch_versions.json
$chocodesiredVersion = (get-content -raw C:\scripts\branch_versions.json | ConvertFrom-Json).choco_App_Version
Invoke-WebRequest -Uri ($baseURI + "/repo/" + $chocodesiredVersion + "/software-list.json" + $sasToken) -UseBasicParsing -OutFile C:\scripts\software-list.json


# Path to the JSON file
$jsonFilePath = "C:\scripts\software-list.json"

# Read the JSON file
$jsonContent = Get-Content -Path $jsonFilePath -Raw | ConvertFrom-Json

# Loop through each package and install it using Chocolatey
foreach ($package in $jsonContent.packages) {
    choco install $package --ignore-checksums -y
}