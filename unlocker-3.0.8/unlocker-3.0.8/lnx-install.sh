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

version=$(grep -i player.product.version /etc/vmware/config | cut -d'"' -f2- | rev | cut -c 2- | rev)
build=$(grep -i product.buildnumber /etc/vmware/config | cut -d'"' -f2- | rev | cut -c 2- | rev)
IFS='.' read -r -a product <<< "$version"

printf "VMware product version: %s.%s\n\n" "$version" "$build"
#printf "Major:    ${product[0]}\n"
#printf "Minor:    ${product[1]}\n"
#printf "Revision: ${product[2]}\n"
#printf "Build:    ${build}\n"

# Check version is 14+
if [[ ${product[0]} -lt 12 ]]; then
   printf "VMware Workstation/Player version 12 or greater required!\n"
   exit 1
fi

# CD to script folder
cd "$(dirname "${BASH_SOURCE[0]}")"

echo Creating backup folder...
rm -rf ./backup 2>/dev/null
mkdir -p ./backup
cp -pv /usr/lib/vmware/bin/vmware-vmx ./backup/
cp -pv /usr/lib/vmware/bin/vmware-vmx-debug ./backup/
if [ -e /usr/lib/vmware/bin/vmware-vmx-stats ]; then
  cp -pv /usr/lib/vmware/bin/vmware-vmx-stats ./backup/
fi
if [ -d /usr/lib/vmware/lib/libvmwarebase.so.0/ ]; then
    cp -pv /usr/lib/vmware/lib/libvmwarebase.so.0/libvmwarebase.so.0 ./backup/
elif [ -d /usr/lib/vmware/lib/libvmwarebase.so/ ]; then
    cp -pv /usr/lib/vmware/lib/libvmwarebase.so/libvmwarebase.so ./backup/
fi

echo Patching...
./unlocker.py

echo Copying VMware Tools...
cp ./iso/darwin*.* /usr/lib/vmware/isoimages/

# CD to original folder
cd -

echo Finished!
