#################################################################
#################################################################
##														       ##
##						Powershell Script					   ##
##															   ##
##		Author: 	                                           ##
##															   ##
##		Date: 											       ##
##															   ##
##		Function: 	Script for the OS build process            ##
##															   ##
##			(c)  GmbH		   ##
##															   ##
#################################################################
#################################################################
# -------------------------------------
# Ultra-Simplified ISO Build Script
# ISO-Name = Ordnername
# Live-Ausgabe von oscdimg
# -------------------------------------

Write-Host "Starte Ultra-Simplified ISO Build Script..." -ForegroundColor Cyan 

# Root-Verzeichnis
$root = (Resolve-Path ".").Path

# Ordnername als ISO-Name
$dirName = Split-Path $root -Leaf
$isoName = ($dirName -replace '[<>:"/\\|?*]', '_') + ".iso"
$isoPath = Join-Path $root $isoName

# Pfade
Write-Host "Setzte Pfade..." -ForegroundColor Cyan
$USB = Join-Path $root "USB"
$payload = Join-Path $root "payload"
$oscdimg = Join-Path $root "bin\oscdimg.exe"

# Boot-Dateien
$etfsboot = Join-Path $USB "boot\etfsboot.com"
$efisys   = Join-Path $USB "efi\microsoft\boot\efisys_noprompt.bin"

# Prüfen
Write-Host "Prüfe Variablen..." -ForegroundColor Cyan
foreach ($f in @($USB,$oscdimg,$etfsboot,$efisys)) {
    if (-not (Test-Path $f)) {
        Write-Host "Fehlt: $f" -ForegroundColor Red
        exit 1
    }
}

# payload -> USB kopieren
if (Test-Path $payload) {
    Write-Host "Kopiere payload nach USB..." -ForegroundColor Cyan
    Copy-Item "$payload\*" $USB -Recurse -Force
	Move-Item -Path $payload\$OEM$ -Destination $USB\sources -Force
}


# Alte ISO löschen
Write-Host "Alte ISO löschen..." -ForegroundColor Cyan
if (Test-Path $isoPath) { Remove-Item $isoPath -Force }

# oscdimg Argumente
$args = @(
    "-bootdata:2#p0,e,b$etfsboot#pEF,e,b$efisys"
    "-m"
    "-o"
    "-u1"
    "-udfver102"
    "-l"
    "`"$USB`""
    "`"$isoPath`""
)

# LIVE-Ausgabe (simple, direkt)
Write-Host "Starte oscdimg..." -ForegroundColor Cyan
& $oscdimg @args 2>&1 | Write-Host

Write-Host "ISO erstellt: $isoPath" -ForegroundColor Green