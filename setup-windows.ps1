#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Script de setup Windows — Jeremy
.DESCRIPTION
    Installation automatisée + rappels manuels pour une config complète.
    Lancer en PowerShell 5 (admin), le script installe PS7 + winget si besoin.
.USAGE
    PowerShell (admin) :
    Set-ExecutionPolicy Bypass -Scope Process -Force
    .\setup-windows.ps1
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Continue"

# ─── Couleurs / helpers ────────────────────────────────────────────────────────

function Write-Step   { param($n, $msg) Write-Host "`n[$n] $msg" -ForegroundColor Cyan }
function Write-Ok     { param($msg)     Write-Host "    ✓ $msg" -ForegroundColor Green }
function Write-Warn   { param($msg)     Write-Host "    ⚠ $msg" -ForegroundColor Yellow }
function Write-Manual { param($msg)     Write-Host "    → $msg" -ForegroundColor Magenta }
function Write-Skip   { param($msg)     Write-Host "    · $msg" -ForegroundColor DarkGray }

function Pause-Manual {
    param($msg)
    Write-Manual $msg
    Read-Host "    Appuie sur Entrée quand c'est fait..."
}

# ─── Vérif winget ─────────────────────────────────────────────────────────────

function Assert-Winget {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Warn "winget non trouvé — ouverture du Microsoft Store pour App Installer..."
        Start-Process "ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1"
        Pause-Manual "Installe 'App Installer' depuis le Store, puis reviens ici"
    } else {
        Write-Ok "winget disponible"
    }
}

# ─── Fonction winget générique ─────────────────────────────────────────────────

function Install-Winget {
    param(
        [string]$Id,
        [string]$Name
    )
    Write-Host "    Installing $Name..." -NoNewline
    $result = winget install --id $Id --silent --accept-package-agreements --accept-source-agreements 2>&1
    if ($LASTEXITCODE -eq 0 -or $LASTEXITCODE -eq -1978335189) {
        # -1978335189 = already installed
        Write-Ok "$Name OK"
    } else {
        Write-Warn "$Name — code $LASTEXITCODE (vérifier manuellement)"
    }
}

# ══════════════════════════════════════════════════════════════════════════════
Write-Host @"

  ╔═══════════════════════════════════════════════════╗
  ║          SETUP WINDOWS — Jeremy                   ║
  ╚═══════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

Assert-Winget

# ─── 1. 1Password ─────────────────────────────────────────────────────────────
Write-Step 1 "1Password"
Install-Winget -Id "AgileBits.1Password" -Name "1Password"

# ─── 2. Drivers depuis le NAS ─────────────────────────────────────────────────
Write-Step 2 "Drivers (NAS ou clé)"
Write-Manual "Ouvre le NAS : \\192.168.1.23"
Pause-Manual "Installe les drivers nécessaires depuis le NAS, puis reviens"

# ─── 3. Brave ─────────────────────────────────────────────────────────────────
Write-Step 3 "Brave Browser"
Install-Winget -Id "Brave.Brave" -Name "Brave"
Write-Manual "Sync Brave : brave://settings/braveSync/setup (utilise ton code de sync Notion)"

# ─── 4. NVIDIA Drivers ────────────────────────────────────────────────────────
Write-Step 4 "NVIDIA App (drivers)"
Install-Winget -Id "Nvidia.NVIDIAApp" -Name "NVIDIA App"
Write-Manual "Si ça foire avec winget : https://www.nvidia.com/fr-fr/software/nvidia-app/"

# ─── 5. PowerShell 7 + profil ChrisTitusTech ──────────────────────────────────
Write-Step 5 "PowerShell 7 + profil CTT"
Install-Winget -Id "Microsoft.PowerShell" -Name "PowerShell 7"
Write-Warn "Le profil CTT doit être lancé dans PowerShell 7 (pas PS5)"
Write-Manual "Dans PowerShell 7 (admin) :"
Write-Manual "  irm 'https://github.com/ChrisTitusTech/powershell-profile/raw/main/setup.ps1' | iex"
Pause-Manual "Lance la commande ci-dessus dans PS7 admin, puis reviens"

# ─── 6. Chocolatey + Winutil (tweaks) ─────────────────────────────────────────
Write-Step 6 "Chocolatey + Winutil (tweaks)"

# Chocolatey
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "    Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    Write-Ok "Chocolatey installé"
} else {
    Write-Skip "Chocolatey déjà présent"
}

Write-Manual "Winutil (tweaks Windows) — dans PS7 admin :"
Write-Manual "  irm 'https://christitus.com/win' | iex"
Pause-Manual "Lance Winutil, applique tes tweaks, puis reviens"

# ─── 7. VSCode + Sync GitHub ──────────────────────────────────────────────────
Write-Step 7 "VSCode"
Install-Winget -Id "Microsoft.VisualStudioCode" -Name "VSCode"
Write-Manual "Sync VSCode : Ctrl+Shift+P → 'Settings Sync: Turn On' → GitHub"
Write-Manual "Extensions Notion : https://www.notion.so/Extensions-cec2244a0cea4a84b4414d6a6ad8b315"

# ─── 8. Spotify ───────────────────────────────────────────────────────────────
Write-Step 8 "Spotify"
Install-Winget -Id "Spotify.Spotify" -Name "Spotify"

# ─── 9. Discord ───────────────────────────────────────────────────────────────
Write-Step 9 "Discord"
Install-Winget -Id "Discord.Discord" -Name "Discord"

# ─── 10. Plex ─────────────────────────────────────────────────────────────────
Write-Step 10 "Plex"
Install-Winget -Id "Plex.Plex" -Name "Plex"

# ─── 11. Steam ────────────────────────────────────────────────────────────────
Write-Step 11 "Steam"
Install-Winget -Id "Valve.Steam" -Name "Steam"

# ─── 12. Elgato CameraHub ─────────────────────────────────────────────────────
Write-Step 12 "Elgato CameraHub"
Install-Winget -Id "Elgato.CameraHub" -Name "CameraHub"

# ─── 13. Elgato Stream Deck ───────────────────────────────────────────────────
Write-Step 13 "Elgato Stream Deck"
Install-Winget -Id "Elgato.StreamDeck" -Name "Stream Deck"

# ─── 14. Logitech G HUB ───────────────────────────────────────────────────────
Write-Step 14 "Logitech G HUB"
Install-Winget -Id "Logitech.GHUB" -Name "Logitech G HUB"

# ─── 15. Firefox ──────────────────────────────────────────────────────────────
Write-Step 15 "Firefox"
Install-Winget -Id "Mozilla.Firefox" -Name "Firefox"
Write-Manual "Settings Firefox (Notion) : https://www.notion.so/Settings-1f07e344a1ad809abc9dc3d71d6187c2"

# ─── 16. VLC ──────────────────────────────────────────────────────────────────
Write-Step 16 "VLC"
Install-Winget -Id "VideoLAN.VLC" -Name "VLC"

# ─── 17. brave-volume-restore ─────────────────────────────────────────────────
Write-Step 17 "brave-volume-restore (ton outil Rust)"
Write-Manual "Récupère le binaire depuis GitHub :"
Write-Manual "  https://github.com/jeremydlny/brave-volume-restore/releases"
Write-Manual "Ou compile avec : cargo build --release"
Pause-Manual "Installe et configure le service brave-volume-restore, puis reviens"

# ─── 18. Firewall blocklist manager ───────────────────────────────────────────
Write-Step 18 "windows-firewall-blocklist-manager (ton outil Rust)"
Write-Manual "Récupère le binaire depuis GitHub :"
Write-Manual "  https://github.com/jeremydlny/firewall/releases"
Write-Manual "Configure la tâche planifiée comme décrit dans le README"
Pause-Manual "Installe et configure le firewall manager, puis reviens"

# ══════════════════════════════════════════════════════════════════════════════

Write-Host @"

  ╔═══════════════════════════════════════════════════╗
  ║   Setup terminé ! Redémarre si besoin.            ║
  ╚═══════════════════════════════════════════════════╝

"@ -ForegroundColor Green

Write-Host "Récap des étapes manuelles restantes :" -ForegroundColor Yellow
Write-Host "  2  → Drivers depuis \\192.168.1.23" -ForegroundColor Magenta
Write-Host "  3  → Sync Brave" -ForegroundColor Magenta
Write-Host "  5  → Profil PS7 (CTT)" -ForegroundColor Magenta
Write-Host "  6  → Winutil tweaks" -ForegroundColor Magenta
Write-Host "  7  → Sync VSCode Extensions" -ForegroundColor Magenta
Write-Host "  15 → Settings Firefox" -ForegroundColor Magenta
Write-Host "  17 → brave-volume-restore service" -ForegroundColor Magenta
Write-Host "  18 → Firewall blocklist + tâche planifiée" -ForegroundColor Magenta
