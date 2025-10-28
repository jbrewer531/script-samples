## Windows Activation Script
## Summary: This script will activate Windows to an OEM key.
## Variable will look at motherboard and pull the OEM key burned into the motherboard then save the OEM key as variable
$test = (Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey
## Adds the OEM key to the system and activates the system.
slmgr /ipk $test