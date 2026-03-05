# ISO-Build
Creating a bootable Windows boot ISO with its own settings
# 📦 Windows‑ISO Build – Projektbeschreibung

Dieses Projekt erstellt automatisiert eine Windows‑Installations‑ISO, die bereits vorkonfigurierte Einstellungen, automatische Benutzeranlage, Programme, Tools, Treiber und Setup‑Skripte enthält.
Der gesamte Build‑Prozess wird über ein einfaches Skript ausgeführt, das:

1. alle benötigten Dateien zusammenstellt
2. den Inhalt des **payload**‑Ordners in die **USB‑Struktur** kopiert
3. `oscdimg.exe` aufruft, um daraus eine bootfähige ISO zu erzeugen
4. die ISO direkt im Projekt-Root mit dem Namen des Ordnernamens ablegt

---

## 🗂 Projektstruktur

```
<ProjectRoot>
│  buildiso.bat
│  <Projektname>.iso (wird erzeugt)
│
├─ USB\
│   ├─ boot\
│   │    etfsboot.com
│   └─ efi\microsoft\boot\
│        efisys_noprompt.bin
│
├─ payload\
│   _autounattend.xml
│   ├─ $OEM$\
│   │   ├─ $$\
│   │   │   └─ Panther\
│   │   │        unattend.xml
│   │   │
│   │   ├─ $1\
│   │   │   └─ Tools\
│   │   │        <Programme, Treiber, Tools>
│   │   │
│   │   └─ $$\
│   │       └─ Setup\
│   │           └─ Scripts\
│   │                <CMD-Skripte>
│   └─ (weitere Dateien)
│
└─ bin\
      oscdimg.exe
```

---

# ⚙️ Was das Script macht (Kurzfassung)

Das `buildiso.bat`‑Script führt die folgenden Schritte durch:

1. Ermittelt automatisch den Namen des Projektordners → Dieser wird der Name der fertigen ISO.
2. Bereitet alle benötigten Pfade vor (USB, payload, oscdimg.exe, Bootdateien).
3. Kopiert **den gesamten Inhalt des Ordners `payload` in den USB‑Ordner**, bevor die ISO gebaut wird.
4. Ruft `oscdimg.exe` mit BIOS+UEFI‑Bootoptionen auf → Die ISO ist voll bootfähig.
5. Erstellt die fertige ISO direkt im Root‑Verzeichnis.

---

# 📝 Wichtige Konfigurationsdateien

## 🔹 `_autounattend.xml` (im `payload`)

- Liegt im Ordner `payload`
- **Ist standardmäßig deaktiviert**, weil sie mit einem **Unterstrich** beginnt
- Sobald diese Datei in **`autounattend.xml`** umbenannt wird:

✔ Die Datei wird von Windows Setup automatisch erkannt
✔ Die Installation startet **vollautomatisch**
✔ Die Festplatte wird vollständig gelöscht („Wipe & Load“)
✔ Das Setup läuft ohne Eingaben durch

‼ WARNUNG: Diese Datei aktiviert unbeaufsichtigte **COMPLETE DISK WIPE**.

---

## 🔹 `.$OEM$\$$\Panther\unattend.xml`

Dieser Pfad landet beim Installieren in:
```
C:\Windows\Panther\unattend.xml
```

Diese Datei ist **aktiv** und wird immer verarbeitet.

---

## 🔹 `.$OEM$\$1\Tools`

Dieser Ordner wird bei der Installation nach:
```
C:\Tools
```
kopiert.

---

## 🔹 `payload\$OEM$\$$\Setup\Scripts`

Dieser Ordner wird zu:
```
C:\Windows\Setup\Scripts
```

---

# 🔧 Was bei der Installation passiert

1. Windows Setup startet
2. Falls `autounattend.xml` aktiv ist → komplette Automatik
3. Setup kopiert `$OEM$`‑Ordner nach Windows-Verzeichnisse
4. Tools werden nach `C:\Tools` kopiert
5. Treiber werden installiert
6. Benutzerkonto wird angelegt
7. Setup-Skripte laufen automatisch
8. Windows startet komplett vorkonfiguriert

---

# 🔒 Sicherheitshinweis

Die Datei `_autounattend.xml` löscht bei Aktivierung durch Umbenennen die gesamte Festplatte. **Nur in VMs oder Testumgebungen verwenden!**

---

# 🎯 Zusammenfassung

Dieses Projekt ermöglicht:
- automatische, unbeaufsichtigte Windows-Installation
- Integration eigener Tools & Treiber
- automatische Benutzeranlage
- Setup-Skripte für Programme & Konfiguration

**Ideal für automatisierte Windows-Deployments.**
