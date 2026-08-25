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

# ─── 2. Firefox ────────────────────────────────────────────────────────────────
Write-Step 2 "Firefox"
Install-Winget -Id "Mozilla.Firefox" -Name "Firefox"

# ─── 3. PowerShell 7 + profil ChrisTitusTech ──────────────────────────────────
Write-Step 3 "PowerShell 7 + profil CTT"
Install-Winget -Id "Microsoft.PowerShell" -Name "PowerShell 7"

# Recharger le PATH pour que pwsh soit dispo sans redémarrer
$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("PATH", "User")

$pwsh = Get-Command pwsh -ErrorAction SilentlyContinue
if ($pwsh) {
    Write-Host "    Installation du profil CTT dans PS7..."
    Start-Process pwsh -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"irm 'https://github.com/ChrisTitusTech/powershell-profile/raw/main/setup.ps1' | iex`"" -Verb RunAs -Wait
    Write-Ok "Profil CTT installé"
} else {
    Write-Warn "pwsh introuvable après installation — redémarre le terminal et lance manuellement :"
    Write-Manual "  irm 'https://github.com/ChrisTitusTech/powershell-profile/raw/main/setup.ps1' | iex"
}

# ─── 4. Chocolatey + Winutil (tweaks) ─────────────────────────────────────────
Write-Step 4 "Chocolatey + Winutil (tweaks)"

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

Write-Host "    Lancement de Winutil dans une nouvelle fenêtre..."
Start-Process pwsh -Verb RunAs -Wait -ArgumentList @(
    "-NoProfile",
    "-ExecutionPolicy", "Bypass",
    "-Command", "irm 'https://christitus.com/win' | iex"
)
Write-Ok "Winutil terminé — reprise du setup"

# ─── 5. Zed ───────────────────────────────────────────────────────────────────
Write-Step 5 "Zed"
Install-Winget -Id "ZedIndustries.Zed" -Name "Zed"

# ─── 6. Spotify ───────────────────────────────────────────────────────────────
Write-Step 6 "Spotify"
Install-Winget -Id "Spotify.Spotify" -Name "Spotify"

# ─── 7. Discord ───────────────────────────────────────────────────────────────
Write-Step 7 "Discord"
Install-Winget -Id "Discord.Discord" -Name "Discord"

# ─── 8. Plex ──────────────────────────────────────────────────────────────────
Write-Step 8 "Plex"
Install-Winget -Id "Plex.Plex" -Name "Plex"

# ─── 9. Steam ─────────────────────────────────────────────────────────────────
Write-Step 9 "Steam"
Install-Winget -Id "Valve.Steam" -Name "Steam"

# ─── 10. Elgato CameraHub ─────────────────────────────────────────────────────
Write-Step 10 "Elgato CameraHub"
Install-Winget -Id "Elgato.CameraHub" -Name "CameraHub"

# ─── 11. Elgato Stream Deck ───────────────────────────────────────────────────
Write-Step 11 "Elgato Stream Deck"
Install-Winget -Id "Elgato.StreamDeck" -Name "Stream Deck"

# ─── 12. Logitech G HUB ───────────────────────────────────────────────────────
Write-Step 12 "Logitech G HUB"
Install-Winget -Id "Logitech.GHUB" -Name "Logitech G HUB"

# ─── 13. Brave ────────────────────────────────────────────────────────────────
Write-Step 13 "Brave Browser"
Install-Winget -Id "Brave.Brave" -Name "Brave"

# ─── 14. VLC ──────────────────────────────────────────────────────────────────
Write-Step 14 "VLC"
Install-Winget -Id "VideoLAN.VLC" -Name "VLC"

# ══════════════════════════════════════════════════════════════════════════════

Write-Host @"

  ╔═══════════════════════════════════════════════════╗
  ║   Setup terminé ! Redémarre si besoin.            ║
  ╚═══════════════════════════════════════════════════╝

"@ -ForegroundColor Green

Write-Host "Récap des configurations à vérifier :" -ForegroundColor Yellow
Write-Host "  2  → Settings Firefox" -ForegroundColor Magenta
Write-Host "  3  → Vérifier le profil PS7 (CTT)" -ForegroundColor Magenta
Write-Host "  4  → Appliquer les tweaks souhaités dans Winutil" -ForegroundColor Magenta
Write-Host "  5  → Configurer Zed / synchronisation si souhaitée" -ForegroundColor Magenta
Write-Host "  13 → Sync Brave" -ForegroundColor Magenta
