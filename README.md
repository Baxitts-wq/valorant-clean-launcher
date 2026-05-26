# valorant-clean-launcher

A simple batch script I made to fix the annoying VAN 102 and VAL 5 errors on Valorant. It closes apps that conflict with Vanguard, resets the network stack, and launches the game automatically. Also runs a background watcher that keeps killing those apps if they restart mid-game.

---

## Why I made this

I kept getting kicked mid-game with VAN 102 / VAL 5 errors. Turns out stuff like Steam, Discord, Logitech G HUB agents and controller remappers can conflict with Vanguard even if you're not doing anything wrong. Instead of manually closing everything before each session I just automated it.

---

## What it does

- Kills Steam, Epic Games, Discord, Logitech G HUB (agent + updater), controller remappers (x360ce, reWASD, Xpadder, JoyToKey), MSI Afterburner, OBS overlays
- Flushes DNS cache
- Resets Winsock and TCP/IP stack
- Renews IP address
- Starts a background monitor that re-kills any of those apps if they come back while you're in game
- Launches the Riot Client directly

---

## Usage

1. Download `LancerValorant.bat`
2. Right-click → **Run as administrator**
3. That's it, Valorant will open on its own

> [!IMPORTANT]
> Must be run as Administrator or the network reset commands won't work.

---

## If Riot Client doesn't launch

The script looks for the client in two default locations:

```
%LOCALAPPDATA%\Riot Games\Riot Client\RiotClientServices.exe
C:\Riot Games\Riot Client\RiotClientServices.exe
```

If yours is somewhere else, open the `.bat` with Notepad and change the `P1` variable at the top to match your actual install path.

---

## Make it always run as admin (optional)

If you want to just double-click without the right-click step every time:

1. Right-click the `.bat` file → **Create shortcut**
2. Right-click the shortcut → **Properties**
3. Click **Advanced** → check **Run as administrator**
4. Use the shortcut from now on

---

## Tested on

- Windows 10 / 11
- Logitech G HUB
- Xbox controller (with and without Steam running)

---

## Note

This doesn't touch any game files or Vanguard itself. It only closes third-party apps before launch. Completely safe to use.
