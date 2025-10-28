# Define variables
$oldUsername = ""
$newUsername = ""
$password = ConvertTo-SecureString "" -AsPlainText -Force
$fullname = ""

# Delete the old user account
Try {
    Remove-LocalUser -Name $oldUsername -ErrorAction Stop
    Write-Host "Deleted user account: $oldUsername"
} Catch {
    Write-Host "Failed to delete user account: $oldUsername. It may not exist."
}

# Create the new user account
Try {
    New-LocalUser -Name $newUsername -Password $password -FullName $fullname -Description "Administrator account" -ErrorAction Stop
    Write-Host "Created new user account: $newUsername"
} Catch {
    Write-Host "Failed to create user account: $newUsername"
    Exit
}

# Add the new user to the Administrators group
Try {
    Add-LocalGroupMember -Group "Administrators" -Member $newUsername -ErrorAction Stop
    Write-Host "Added $newUsername to Administrators group"
} Catch {
    Write-Host "Failed to add $newUsername to Administrators group"
}
