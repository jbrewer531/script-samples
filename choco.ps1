#######Choco Installs
$baseURI = "URL"
$sasToken = "Token"

$Phone_App_version = $baseURI + $blobPath + $sasToken    
Invoke-WebRequest -Uri $Phone_App_version -UseBasicParsing -OutFile C:\init\branch_versions.json
$chocodesiredVersion = (get-content -raw C:\init\branch_versions.json | ConvertFrom-Json).Phone_App_Version
Invoke-WebRequest -Uri ($baseURI + "random azure blob path" + $chocodesiredVersion + "/software-list.json" + $sasToken) -UseBasicParsing -OutFile C:\init\software-list.json


# Path to the JSON file
$jsonFilePath = "C:\init\software-list.json"

# Read the JSON file
$jsonContent = Get-Content -Path $jsonFilePath -Raw | ConvertFrom-Json

# Loop through each package and install it using Chocolatey
foreach ($package in $jsonContent.packages) {
    choco install $package -y