@echo off
setlocal ENABLEEXTENSIONS
echo.
echo Unlocker 3.0.8 for VMware Workstation
echo =====================================
echo (c) David Parsons 2011-21
echo.
echo Set encoding parameters...
chcp 850

net session >NUL 2>&1
if %errorlevel% neq 0 (
    echo Administrator privileges required!
    pause
    exit /b
)

echo.
set KeyName="HKLM\SOFTWARE\Wow6432Node\VMware, Inc.\VMware Player"
for /F "tokens=2*" %%A in ('REG QUERY %KeyName% /v InstallPath') do set InstallPath=%%B
echo VMware is installed at: %InstallPath%
for /F "tokens=2*" %%A in ('REG QUERY %KeyName% /v ProductVersion') do set ProductVersion=%%B
echo VMware product version: %ProductVersion%
for /F "tokens=1,2,3,4 delims=." %%a in ("%ProductVersion%") do (
   set Major=%%a
   set Minor=%%b
   set Revision=%%c
   set Build=%%d
)

:: echo Major: %Major%, Minor: %Minor%, Revision: %Revision%, Build: %Build%

:: Check version is 12+
if %Major% lss 12 (
    echo VMware Workstation/Player version 12 or greater required!
    pause
    exit /b
)

pushd %~dp0

echo.
echo Stopping VMware services...
net stop vmware-view-usbd > NUL 2>&1
net stop VMwareHostd > NUL 2>&1
net stop VMAuthdService > NUL 2>&1
net stop VMUSBArbService > NUL 2>&1
taskkill /F /IM vmware-tray.exe > NUL 2>&1

echo.
echo Backing up files...
rd /s /q .\backup > NUL 2>&1
mkdir .\backup
mkdir .\backup\x64
xcopy /F /Y /X "%InstallPath%x64\vmware-vmx.exe" .\backup\x64
xcopy /F /Y /X "%InstallPath%x64\vmware-vmx-debug.exe" .\backup\x64
if exist "%InstallPath%x64\vmware-vmx-stats.exe" xcopy /F /Y /X "%InstallPath%x64\vmware-vmx-stats.exe" .\backup\x64
xcopy /F /Y /X "%InstallPath%vmwarebase.dll" .\backup\

echo.
echo Patching...
.\python-win-embed-amd64\python.exe unlocker.py

echo.

echo Copying VMware Tools...
xcopy /F /Y /X .\iso\darwin*.* "%InstallPath%"
echo.

echo Starting VMware services...
net start VMUSBArbService > NUL 2>&1
net start VMAuthdService > NUL 2>&1
net start VMwareHostd > NUL 2>&1
net start vmware-view-usbd > NUL 2>&1

popd
echo.
echo Finished!
pause
