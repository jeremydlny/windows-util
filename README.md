# windows-util

Script de setup Windows — installation automatisée + rappels manuels pour une config complète from scratch.

## Lancement

Dans **PowerShell en admin** :

```powershell
irm https://raw.githubusercontent.com/jeremydlny/windows-util/main/setup-windows.ps1 | iex
```

> Le script nécessite les droits admin (`#Requires -RunAsAdministrator`).  
> Si PowerShell bloque l'exécution, utilise cette variante :
> ```powershell
> Set-ExecutionPolicy Bypass -Scope Process -Force; irm https://raw.githubusercontent.com/jeremydlny/windows-util/main/setup-windows.ps1 | iex
> ```

---

## Ce que fait le script

Les étapes **automatiques** sont installées silencieusement via winget ou compilées depuis les sources.  
Les étapes **manuelles** mettent le script en pause et attendent que tu confirmes avant de continuer.

| # | App | Mode | winget ID / source |
|---|-----|------|--------------------|
| 1 | 1Password | auto | `AgileBits.1Password` |
| 3 | Brave | auto + sync manuel | `Brave.Brave` |
| 4 | NVIDIA App | auto | `Nvidia.NVIDIAApp` |
| 5 | PowerShell 7 + profil CTT | auto + config manuelle | `Microsoft.PowerShell` |
| 6 | Chocolatey + Winutil tweaks | auto + tweaks manuels | — |
| 7 | VSCode | auto + sync GitHub manuel | `Microsoft.VisualStudioCode` |
| 8 | Spotify | auto | `Spotify.Spotify` |
| 9 | Discord | auto | `Discord.Discord` |
| 10 | Plex | auto | `Plex.Plex` |
| 11 | Steam | auto | `Valve.Steam` |
| 12 | Elgato CameraHub | auto | `Elgato.CameraHub` |
| 13 | Elgato Stream Deck | auto | `Elgato.StreamDeck` |
| 14 | Logitech G HUB | auto | `Logitech.GHUB` |
| 15 | Firefox | auto + settings manuels | `Mozilla.Firefox` |
| 16 | VLC | auto | `VideoLAN.VLC` |
| 16.5 | Visual Studio Build Tools (C++) | auto | `Microsoft.VisualStudio.2022.BuildTools` |
| 16.5 | Visual Studio Build Tools (C++) | auto | `Microsoft.VisualStudio.2022.BuildTools` |
| 17 | [brave-volume-restore](https://github.com/jeremydlny/brave-volume-restore) | auto | clone + `cargo build` + `install.bat` |
| 18 | [firewall_blocker](https://github.com/jeremydlny/firewall) | auto | clone + `cargo build` + `--install-task` |

> Les étapes 17 et 18 nécessitent **Rust** et **Visual Studio Build Tools avec le workload C++**. Le script installe les deux automatiquement si absents.

---

## Étapes manuelles détaillées


**3 — Brave Sync**  
Une fois Brave installé : `brave://settings/braveSync/setup`

**5 — Profil PowerShell (CTT)**  
Dans PowerShell 7 en admin :
```powershell
irm 'https://github.com/ChrisTitusTech/powershell-profile/raw/main/setup.ps1' | iex
```

**6 — Winutil (tweaks Windows)**  
Dans PowerShell 7 en admin :
```powershell
irm 'https://christitus.com/win' | iex
```

**7 — VSCode Sync**  
`Ctrl+Shift+P` → *Settings Sync: Turn On* → GitHub

**15 — Firefox Settings**  
Voir les settings dans Notion.

---

## Prérequis

- Windows 10/11
- winget (App Installer) — le script ouvre le Store automatiquement s'il est absent
- Droits administrateur
- git (pour les étapes 17 et 18)
- Visual Studio Build Tools avec workload **Desktop development with C++** — installé automatiquement à l'étape 16.5
