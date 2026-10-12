#!/bin/bash

# disable wifi hotspot (run it on mirte), by disabling the check_connection function in network_setup.sh
sed -i 's/^check_connection/\#check_connection/' /usr/local/src/mirte/mirte-install-scripts/network_setup.sh 
sync # to make sure the changes are written to disk
# after reboot, the wifi hotspot will be disabled, and mirte will not try start it.


# Enable wifi hotspot again, need to restart mirte-ap.service after running this script
# sed -i 's/^\#check_connection/check_connection/' /usr/local/src/mirte/mirte-install-scripts/network_setup.sh 


# To check if the wifi hotspot is disabled, you can run the following command:
# cat /usr/local/src/mirte/mirte-install-scripts/network_setup.sh 
