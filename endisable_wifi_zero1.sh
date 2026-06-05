#!/bin/bash
set -xe
ROOT_DIR=/media/arendjan/armbi_root/


# disable wifi on zero1
if true; then

sed -i 's/^check_connection/\#check_connection/' $ROOT_DIR/usr/local/src/mirte/mirte-install-scripts/network_setup.sh 


else

sed -i 's/^\#check_connection/check_connection/' $ROOT_DIR/usr/local/src/mirte/mirte-install-scripts/network_setup.sh 
fi