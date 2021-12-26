#!/bin/bash
set -e

echo "Unlocker 3.0.8 for VMware Workstation"
echo "====================================="
echo "(c) David Parsons 2011-21"

# Ensure we only use unmodified commands
export PATH=/bin:/sbin:/usr/bin:/usr/sbin

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# CD to script folder
cd "$(dirname "${BASH_SOURCE[0]}")"

echo Restoring files...
cp -pv ./backup/vmware-vmx  /usr/lib/vmware/bin/
cp -pv ./backup/vmware-vmx-debug /usr/lib/vmware/bin/
cp -pv ./backup/vmware-vmx-stats /usr/lib/vmware/bin/
if [ -d /usr/lib/vmware/lib/libvmwarebase.so.0/ ]; then
    cp -pv ./backup/libvmwarebase.so.0 /usr/lib/vmware/lib/libvmwarebase.so.0/
elif [ -d /usr/lib/vmware/lib/libvmwarebase.so/ ]; then
    cp -pv ./backup/libvmwarebase.so /usr/lib/vmware/lib/libvmwarebase.so/
fi

echo Removing backup files...
rm -rfv ./backup

# CD to original folder
cd -

echo Finished!
