## Windows Activation Reset
##Summary: Resets Windows Activation processes

## Removes current product key and puts Windows in an unlicensed state
slmgr /upk
## Removes the current key from the registry if it is still populated there.
slmgr /cpky
## This resets the Windows Activation process and will set the system back to a pre-key state
slmgr /rearm
## Rebooting system
Restart-Computer -Force