@echo off
setlocal EnableExtensions EnableDelayedExpansion

echo.
echo === ISO Build Script (Batch) ===

ECHO Root = aktuelles Verzeichnis
set "root=%cd%"

ECHO Ordnername als ISO-Name (ungültige Zeichen ersetzen)
for %%A in ("%root%") do set "dirname=%%~nxA"
set "isoname=%dirname%"
set "iso=%root%\%isoname%.iso"

ECHO check Pfade
set "USB=%root%\USB"
set "PAYLOAD=%root%\payload"
set "OEM=%roo%\payload\$OEM$"
set "OSCDIMG=%root%\bin\oscdimg.exe"

set "ETFSBOOT=%USB%\boot\etfsboot.com"
set "EFISYS=%USB%\efi\microsoft\boot\efisys_noprompt.bin"

echo.
echo Verzeichnis:     %root%
echo ISO-Datei:       %iso%
echo USB-Quelle:      %USB%
echo Payload:         %PAYLOAD%
echo $OEM$:           %OEM%
echo oscdimg.exe:     %OSCDIMG%
echo.

ECHO Prüfen ob alle benötigten Dateien existieren
if not exist "%OSCDIMG%" (echo FEHLT: oscdimg.exe & exit /b 1)
if not exist "%USB%" (mkdir %root%\usb)
if not exist "%USB%" (echo FEHLT: USB Ordner & exit /b 1)
if not exist "%ETFSBOOT%" (echo FEHLT: %ETFSBOOT% & exit /b 1)
if not exist "%EFISYS%" (echo FEHLT: %EFISYS% & exit /b 1)

ECHO Payload → USB kopieren
if exist "%PAYLOAD%" (
    echo Kopiere payload nach USB...
    xcopy "%PAYLOAD%\*" "%USB%\" /E /H /Y >nul
    move "%USB%\$OEM$" "%USB%\sources" >nul
)

ECHO Alte ISO löschen
if exist "%iso%" del "%iso%"

echo.
echo Starte oscdimg...
echo.

ECHO LIVE-AUSGABE!
"%OSCDIMG%" ^
 -bootdata:2#p0,e,b"%ETFSBOOT%"#pEF,e,b"%EFISYS%" ^
 -m -o -u1 -udfver102 -l ^
 "%USB%" "%iso%"

echo.
echo === ISO erstellt: %iso% ===
echo.

endlocal
