# windows-util

Windows setup script — automated installation + manual reminders for a complete from-scratch configuration.

## Launch

In **PowerShell as admin**:

```powershell
irm https://raw.githubusercontent.com/jeremydlny/windows-util/main/setup-windows.ps1 | iex
```

> The script requires admin rights (`#Requires -RunAsAdministrator`).
> If PowerShell blocks execution, use this variant:
> ```powershell
> Set-ExecutionPolicy Bypass -Scope Process -Force; irm https://raw.githubusercontent.com/jeremydlny/windows-util/main/setup-windows.ps1 | iex
> ```

---

## What the script does

**Automatic** steps are installed silently via winget or compiled from source.
**Manual** steps pause the script and wait for your confirmation before continuing.

| # | App | Mode | winget ID / source |
|---|-----|------|--------------------|
| 1 | 1Password | auto | `AgileBits.1Password` |
| 3 | Brave | auto + manual sync | `Brave.Brave` |
| 4 | NVIDIA App | auto | `Nvidia.NVIDIAApp` |
| 5 | PowerShell 7 + CTT profile | auto + manual config | `Microsoft.PowerShell` |
| 6 | Chocolatey + Winutil tweaks | auto + manual tweaks | — |
| 7 | VSCode | auto + manual GitHub sync | `Microsoft.VisualStudioCode` |
| 8 | Spotify | auto | `Spotify.Spotify` |
| 9 | Discord | auto | `Discord.Discord` |
| 10 | Plex | auto | `Plex.Plex` |
| 11 | Steam | auto | `Valve.Steam` |
| 12 | Elgato CameraHub | auto | `Elgato.CameraHub` |
| 13 | Elgato Stream Deck | auto | `Elgato.StreamDeck` |
| 14 | Logitech G HUB | auto | `Logitech.GHUB` |
| 15 | Firefox | auto + manual settings | `Mozilla.Firefox` |
| 16 | VLC | auto | `VideoLAN.VLC` |
| 16.5 | Visual Studio Build Tools (C++) | auto | `Microsoft.VisualStudio.2022.BuildTools` |
| 16.5 | Visual Studio Build Tools (C++) | auto | `Microsoft.VisualStudio.2022.BuildTools` |
| 17 | [brave-volume-restore](https://github.com/jeremydlny/brave-volume-restore) | auto | clone + `cargo build` + `install.bat` |
| 18 | [firewall_blocker](https://github.com/jeremydlny/firewall) | auto | clone + `cargo build` + `--install-task` |

> Steps 17 and 18 require **Rust** and **Visual Studio Build Tools with the C++ workload**. The script installs both automatically if missing.

---

## Detailed manual steps

**3 — Brave Sync**
Once Brave is installed: `brave://settings/braveSync/setup`

**5 — PowerShell Profile (CTT)**
In PowerShell 7 as admin:
```powershell
irm 'https://github.com/ChrisTitusTech/powershell-profile/raw/main/setup.ps1' | iex
```

**6 — Winutil (Windows tweaks)**
In PowerShell 7 as admin:
```powershell
irm 'https://christitus.com/win' | iex
```

**7 — VSCode Sync**
`Ctrl+Shift+P` → *Settings Sync: Turn On* → GitHub

**15 — Firefox Settings**
See settings in Notion.

---

## Prerequisites

- Windows 10/11
- winget (App Installer) — the script opens the Store automatically if missing
- Administrator rights
- git (for steps 17 and 18)
- Visual Studio Build Tools with **Desktop development with C++** workload — installed automatically at step 16.5
