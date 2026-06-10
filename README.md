# valorant-clean-launcher

Scripts I made to deal with VAN 102 and VAL 5 errors on Valorant. Been getting kicked mid-game for weeks — turns out it was a mix of conflicting software and Vanguard failing to reconnect after repeated crashes. These two scripts fix both problems.

---

## Files

| File | What it does |
|------|-------------|
| `LancerValorant.bat` | Closes conflicting apps, resets network, launches Valorant + background monitor |
| `ReinstallVanguard.bat` | Full Vanguard reinstall — use this when VAN 102 keeps coming back |

---

## LancerValorant.bat

Run this every time before you play.

**What it closes:**
- Steam, Epic Games, GOG, Origin, Battle.net
- Logitech G HUB (agent + updater), Corsair iCUE, Razer, SteelSeries
- Controller remappers — x360ce, reWASD, DS4Windows, Xpadder, JoyToKey
- MSI Afterburner, RivaTuner, OBS, Overwolf, Medal.tv, Bandicam
- VPNs — NordVPN, ExpressVPN, Surfshark, ProtonVPN, OpenVPN
- Macro tools — AutoHotKey, AutoIt
- Remote desktop — TeamViewer, AnyDesk, Parsec

**What it does to the network:**
- Flushes DNS cache
- Resets Winsock
- Resets TCP/IP stack
- Releases and renews IP
- Clears ARP cache

**Background monitor:**
Runs silently while you play. Every 5 seconds it checks if `vgc.exe` is still alive. If Vanguard crashes mid-game it instantly kills anything that might have caused it and sends you a Windows notification. If it crashes twice it asks if you want to close Valorant and run the reinstall.

Discord stays open.

**Usage:**
1. Download `LancerValorant.bat`
2. Double-click — it auto-elevates to admin
3. Valorant opens on its own

---

## ReinstallVanguard.bat

Use this if VAN 102 keeps happening even after using the launcher. This is what Riot Support told me to do and it actually fixed it.

Based on the exact steps from Riot Support agent Genericow.

**What it does:**
- Deletes `C:\Windows\vgkbootstatus.dat`
- Kills all Riot and Vanguard processes
- Runs `sc delete vgc` and `sc delete vgk`
- Cleans leftover registry entries
- Restarts your PC automatically

**Usage:**
1. Close Valorant completely
2. Double-click `ReinstallVanguard.bat` — auto-elevates to admin
3. Press any key to confirm
4. PC restarts in 10 seconds
5. After restart — launch Valorant, Vanguard reinstalls itself
6. If it asks to restart again — do it (Restart, not Shut down)

---

## If Riot Client doesn't launch

The launcher checks these paths by default:

```
%LOCALAPPDATA%\Riot Games\Riot Client\RiotClientServices.exe
C:\Riot Games\Riot Client\RiotClientServices.exe
C:\Program Files\Riot Games\Riot Client\RiotClientServices.exe
```

If your install is somewhere else open `LancerValorant.bat` in Notepad and update the `P1` line.

---

## Tested on

- Windows 10 / 11
- Logitech G HUB (mouse + keyboard)
- Xbox controller

---

## Note

Neither script modifies game files or touches Vanguard directly. `LancerValorant.bat` closes third-party apps. `ReinstallVanguard.bat` removes the service entries so Vanguard can reinstall cleanly — same thing Riot Support walks you through manually.
