@echo off
echo Drücke belibige Tate um RSAT-Tools zu installieren
::pause

powershell.exe -executionpolic bypass -c "Add-WindowsCapability -Online -Name Rsat.DHCP.Tools~~~~0.0.1.0"
powershell.exe -executionpolic bypass -c "Add-WindowsCapability -Online -Name Rsat.Dns.Tools~~~~0.0.1.0"
powershell.exe -executionpolic bypass -c "Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0"
powershell.exe -executionpolic bypass -c "Add-WindowsCapability -Online -Name Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0"
powershell.exe -executionpolic bypass -c "Add-WindowsCapability -Online -Name Rsat.ServerManager.Tools~~~~0.0.1.0"
powershell.exe -executionpolic bypass -c "Add-WindowsCapability -Online -Name Rsat.FileServices.Tools~~~~0.0.1.0"

