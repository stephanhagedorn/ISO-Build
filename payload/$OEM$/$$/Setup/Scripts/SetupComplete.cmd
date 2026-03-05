@echo off

:SLP
:: if exist %systemroot%\setup\scripts\slp.cmd call %systemroot%\setup\scripts\slp.cmd
:: if exist %systemroot%\setup\scripts\slp.cmd del /F /Q %systemroot%\setup\scripts\slp.cmd
:: 
:: 
:: :UPDATES
:: WUSA.EXE %SYSTEMDRIVE%\hotfix\Windows6.1-KB2482122-%PROCESSOR_ARCHITECTURE%.msu /quiet /noreboot
:: 
:: :CUSTOMIZATIONS
:: if not exist %systemroot%\panther mkdir %systemroot%\panther 
:: if not exist %systemroot%\panther\unattend.xml copy %systemroot%\setup\scripts\unattend.xml %systemroot%\panther\unattend.xml
:: call %systemroot%\system32\oem\ie.bat

REG ADD HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnceEx
SET KEY=HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnceEx
REG ADD %KEY% /V TITLE /D "Installing applications" /f
set AppsPath=Tools\

:all
echo All
REG ADD %KEY%\195 /VE /D "DriverInstall" /f
REG ADD %KEY%\195 /V 1 /D "%systemdrive%\%AppsPath%\installDriver.cmd"

REG ADD %KEY%\295 /VE /D "7zip" /f
REG ADD %KEY%\295 /V 1 /D "%systemdrive%\%AppsPath%\7z2600-x64.exe /S"

REG ADD %KEY%\950 /VE /D "Admin Password Never Expires" /f
REG ADD %KEY%\950 /V 1 /D "cmd /C wmic useraccount where name="user0" set PasswordExpires=false" /f

:OsType
for /f "tokens=3" %%a in ('wmic os get Caption /value') do Set OSType=%%a
echo found a %OSType%
if %OSType%==Server goto SrvOS

:ClientOS
echo ClientOS
reg ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "EnableFirstLogonAnimation" /t REG_DWORD /d "0" /f

REG ADD %KEY%\015 /VE /D "Setting Network Dedection" /f
REG ADD %KEY%\015 /V 1 /D "reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff /f"

::REG ADD %KEY%\055 /VE /D "Google Chrome" /f
::REG ADD %KEY%\055 /V 1 /D "msiexec /i %systemdrive%\%AppsPath%\googlechromestandaloneenterprise64.msi /q" /f

REG ADD %KEY%\075 /VE /D "Notepad++" /f
REG ADD %KEY%\075 /V 1 /D "%systemdrive%\%AppsPath%\npp.8.9.2.Installer.exe /S" /f

goto CleanUp

:SrvOS
Echo ServerOS

REG ADD %KEY%\535 /VE /D "Setting ServerManager" /f
REG ADD %KEY%\535 /V 1 /D "REG.exe Add HKCU\Software\Microsoft\ServerManager /V DoNotOpenServerManagerAtLogon /t REG_DWORD /D 0x1 /F"

REG ADD %KEY%\555 /VE /D "Windows Admin Center v2110" /f
REG ADD %KEY%\555 /V 1 /D "msiexec /i %systemdrive%\%AppsPath%\WindowsAdminCenter2110.msi /q" 

REG ADD %KEY%\990 /VE /D "Post Install Script" /f
REG ADD %KEY%\990 /V 1 /D "powershell -ExecutionPolicy Bypass -File %systemdrive%\Tools\PostInstall.ps1" /f



:CLEANUP
:: del /F /Q %systemroot%\setup\scripts\oobe.cmd

::EXIT
echo %date% %time% >c:\StartComplete.txt