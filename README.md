# windows-util

Windows setup script — automated installation and configuration for a complete from-scratch Windows setup.

## Launch

In **PowerShell as administrator**:

```powershell
irm https://raw.githubusercontent.com/jeremydlny/windows-util/main/setup-windows.ps1 | iex
```

> The script requires administrator rights (`#Requires -RunAsAdministrator`).
>
> If PowerShell blocks execution, use this variant:
>
> ```powershell
> Set-ExecutionPolicy Bypass -Scope Process -Force; irm https://raw.githubusercontent.com/jeremydlny/windows-util/main/setup-windows.ps1 | iex
> ```

---

## What the script does

Most applications are installed silently via `winget`.

Some tools require additional configuration after installation, while Winutil and the Chris Titus Tech PowerShell profile are launched automatically by the script.

| #  | App / Tool                  | Mode                               | winget ID / source                |
| -- | --------------------------- | ---------------------------------- | --------------------------------- |
| 1  | 1Password                   | Automatic                          | `AgileBits.1Password`             |
| 2  | Helium                      | Automatic + settings               | `imputnet.Helium`                 |
| 3  | PowerShell 7 + CTT profile  | Automatic + configuration check    | `Microsoft.PowerShell`            |
| 4  | Chocolatey + Winutil tweaks | Automatic + user tweaks            | Chocolatey + `christitus.com/win` |
| 5  | Zed                         | Automatic + optional configuration | `ZedIndustries.Zed`               |
| 6  | Spotify                     | Automatic                          | `Spotify.Spotify`                 |
| 7  | Discord                     | Automatic                          | `Discord.Discord`                 |
| 8  | Plex                        | Automatic                          | `Plex.Plex`                       |
| 9  | Steam                       | Automatic                          | `Valve.Steam`                     |
| 10 | Elgato CameraHub            | Automatic                          | `Elgato.CameraHub`                |
| 11 | Elgato Stream Deck          | Automatic                          | `Elgato.StreamDeck`               |
| 12 | Logitech G HUB              | Automatic                          | `Logitech.GHUB`                   |
| 13 | Brave Browser               | Automatic + sync                   | `Brave.Brave`                     |
| 14 | VLC                         | Automatic                          | `VideoLAN.VLC`                    |

---

## Configuration to verify

### 2 — Helium Settings

Apply your preferred Helium settings after installation.

### 3 — PowerShell 7 + Chris Titus Tech profile

The script installs PowerShell 7 and launches the CTT PowerShell profile setup automatically.

Verify that the profile was installed correctly.

### 4 — Winutil

The script installs Chocolatey if necessary, then launches Winutil automatically in a separate elevated PowerShell window.

Apply the Windows tweaks you want in Winutil, then close it to allow the setup script to continue.

### 5 — Zed

Configure Zed and enable synchronization if desired.

### 13 — Brave Sync

Once Brave is installed, configure Brave Sync:

```text
brave://settings/braveSync/setup
```

---

## Prerequisites

* Windows 10 or Windows 11
* Administrator rights
* `winget` / App Installer

If `winget` is missing, the script opens the Microsoft Store so you can install App Installer before continuing.

---

## Author

Created by [Jeremy Delannoy](https://github.com/jeremydlny)
