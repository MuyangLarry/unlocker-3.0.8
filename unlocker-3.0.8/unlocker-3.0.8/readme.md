# macOS Unlocker V3.0 for VMware Workstation

## This is the last release of the Python based unlocker. There is a new Go language port which is available here:
## https://github.com/DrDonk/golocker/releases

---
**IMPORTANT**
---
1. Use a release from the Releases section of this GitHub repository. https://github.com/DrDonk/unlocker/releases
2. Always uninstall the previous version of the Unlocker before using a new version or 
running an update on the VMware software. Failure to do this could render VMware unusable. 
3. You use this software at your own risk and there are no guarantees this will work 
in future versions of VMware Workstation.

## 1. Introduction
Unlocker 3 is designed for VMware Workstation 12-16 and Player 12-16.

Version 3 has been tested against:

* Workstation 12/14/15/16 on Windows and Linux
* Workstation Player 12/14/15/16 on Windows and Linux


It is important to understand that the unlocker does not add any new capabilities to VMware Workstation and Player
but enables support for macOS that is disabled in the VMware products that do not run on Apple Hardware. 
These capabiltiites are normally exposed in Fusion and ESXi when running on Apple hardware. The unlocker cannot add 
support for new versions of macOS, add paravirtualized GPU support or any other features that are not already in the
VMware compiled code.

What the unlocker can do is enable certain flags and data tables that are required to see the macOS type when setting 
the guest OS type, and modify the implmentation of the virtual SMC controller device.
The patch code carries out the following modifications dependent on the product
being patched:

* Fix vmware-vmx and derivatives to allow macOS to boot
* Fix vmwarebase.dll or .so to allow Apple to be selected during VM creation
* Provide a copy of the macOS VMware Tools for the guest

In all cases make sure VMware is not running, and any background guests have been shutdown.

The code is written in Python with some Bash and Command files.

## 2. Prerequisites
The code requires Python 3.6 to work. Most Linux distros ship with a compatible
Python interpreter and should work without requiring any additional software.

Windows Unlocker has a packaged minimal version of the Python and so does not require Python to be installed.


## 3. Windows
On Windows you will need to either run cmd.exe as Administrator or using
Explorer right click on the command file and select "Run as administrator".

- win-install.cmd   - patches VMware
- win-uninstall.cmd - restores VMware

## 4. Linux
On Linux you will need to be either root or use sudo to run the scripts.

You may need to ensure the Linux scripts have execute permissions
by running chmod +x against the 2 files.

- lnx-install.sh   - patches VMware
- lnx-uninstall.sh - restores VMware
   

## 5. VMware Downloads

These URLs will link to the latest versions of VMware's hosted products:

* VMware Fusion https://vmware.com/go/getfusion
* VMware Workstation for Windows https://www.vmware.com/go/getworkstation-win
* VMware Workstation for Linux https://www.vmware.com/go/getworkstation-linux
* VMware Player for Windows https://www.vmware.com/go/getplayer-win
* VMware Player for Linux https://www.vmware.com/go/getplayer-linux

## 6. VMware Tools
The unlocker provides the VMware tools ISO images. There can be newer releases available which can be downloaded
from these URLs if the script has not yet been updated:

* Mac OS X 10.5 - 10.10 https://customerconnect.vmware.com/en/downloads/details?downloadGroup=VMTOOLS10012&productId=491
* macOS 10.11+ https://customerconnect.vmware.com/downloads/info/slug/datacenter_cloud_infrastructure/vmware_tools/11_x

_These URLs require a VMware login to download._

Version 15 and 16 of Workstation do recognise the darwin.iso files and the tools can be installed in the usual way by 
using the "Install VMware Tools" menu item.

Earlier versions of VMware Workstation and Player do not recognise the darwin.iso via install tools menu item.
You will have to manually mount the darwin.iso by selecting the ISO file in the guest's settings.

## 7. EFI Patcher

This has been removed from the unlocker as it is not working as expected and older versions of Mac OS X do not boot
correctly on modern CPUs. 

## 8. Alternative patcher

https://github.com/paolo-projects/auto-unlocker


## 9 Thanks
Thanks to Zenith432 for originally building the C++ unlocker and Mac Son of Knife
(MSoK) for all the testing and support.

Thanks also to Sam B for finding the solution for ESXi 6 and helping me with
debugging expertise. Sam also wrote the code for patching ESXi ELF files and
modified the unlocker code to run on Python 3 in the ESXi 6.5 environment.


## History
27/09/18 3.0.0
- First release

02/10/18 3.0.1
- Fixed gettools.py to work with Python 3 and correctly download darwinPre15.iso

10/10/18 3.0.2 
- Fixed false positives from anti-virus software with Windows executables   
- Allow Python 2 and 3 to run the Python code from Bash scripts

14/05/21 3.0.3
- New simpfiled code for development and deployment
- Removed Python 2 support and requires minmal Python 3.8

01/06/21 3.0.4
- Fixed embedded Python error on Windows

12/10/21 3.0.5
- Updated gettools.py to directly download tools from new repo
- Added URLs to get Mac OS X legacy and macOS current tools
- Added URLs to get latest VMware hosted products
- Made minimum Python version 3.6 from 3.8 for Linux

14/10/21 3.0.6
- Ensure errors are displayed on Windows if CMD file is run from Explorer

22/10/21 3.0.7
- Tested with Player and Workstation 16.2.0
- Tested with Windows 11 as host
- Do not try to copy vmware-vmx-stats if Player is installed as it is not shipped with Player

05/12/21 3.0.8
- Removed the UEFI ROM patching as not functioning correctly
- Tools ISO files now shipped in the release

(c) 2011-2021 David Parsons
