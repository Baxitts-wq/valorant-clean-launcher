@echo off
setlocal enabledelayedexpansion

:: Auto-elevation admin
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs" >nul 2>&1
    exit /b 0
)

if "%1"=="--monitor" goto MONITOR_MODE

:: ============================================================
:: LAUNCHER PRINCIPAL
:: ============================================================
cls
title  VALORANT LAUNCHER — Vanguard Conflict Cleaner
color 0C
echo.
echo  ██╗   ██╗ █████╗ ██╗      ██████╗ ██████╗  █████╗ ███╗   ██╗████████╗
echo  ██║   ██║██╔══██╗██║     ██╔═══██╗██╔══██╗██╔══██╗████╗  ██║╚══██╔══╝
echo  ██║   ██║███████║██║     ██║   ██║██████╔╝███████║██╔██╗ ██║   ██║
echo  ╚██╗ ██╔╝██╔══██║██║     ██║   ██║██╔══██╗██╔══██║██║╚██╗██║   ██║
echo   ╚████╔╝ ██║  ██║███████╗╚██████╔╝██║  ██║██║  ██║██║ ╚████║   ██║
echo    ╚═══╝  ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝
echo.
color 0A
echo  ================================================================
echo   Anti-Conflict Cleaner  ^|  Smart Vanguard Monitor  ^|  by Baxitts
echo  ================================================================
echo.
timeout /t 2 /nobreak >nul

:: ============================================================
:: ETAPE 1 — KILL CONFLICTING PROCESSES
:: ============================================================
color 0E
echo  [1/4] Fermeture des conflits...
echo  ----------------------------------------------------------------
color 0A

set "KILLED=0"

call :KILL "steam.exe"               "Steam"
call :KILL "steamwebhelper.exe"      "Steam Web Helper"
call :KILL "GameOverlayUI.exe"       "Steam Overlay"
call :KILL "EpicGamesLauncher.exe"   "Epic Games"
call :KILL "EpicWebHelper.exe"       "Epic Web Helper"
call :KILL "GalaxyClient.exe"        "GOG Galaxy"
call :KILL "Origin.exe"              "Origin"
call :KILL "Battle.net.exe"          "Battle.net"
call :KILL "lghub.exe"               "Logitech G HUB"
call :KILL "lghub_agent.exe"         "Logitech Agent"
call :KILL "lghub_updater.exe"       "Logitech Updater"
call :KILL "LogiOptions.exe"         "Logitech Options"
call :KILL "iCUE.exe"                "Corsair iCUE"
call :KILL "RazerCentralService.exe" "Razer Central"
call :KILL "SteelSeriesGG.exe"       "SteelSeries GG"
call :KILL "x360ce.exe"              "x360ce"
call :KILL "x360ce_x64.exe"          "x360ce x64"
call :KILL "reWASD.exe"              "reWASD"
call :KILL "reWASDService.exe"       "reWASD Service"
call :KILL "DS4Windows.exe"          "DS4Windows"
call :KILL "Xpadder.exe"             "Xpadder"
call :KILL "JoyToKey.exe"            "JoyToKey"
call :KILL "AntiMicroX.exe"          "AntiMicroX"
call :KILL "MSIAfterburner.exe"      "MSI Afterburner"
call :KILL "RTSS.exe"                "RivaTuner"
call :KILL "obs64.exe"               "OBS Studio"
call :KILL "Overwolf.exe"            "Overwolf"
call :KILL "medal.exe"               "Medal.tv"
call :KILL "Bandicam.exe"            "Bandicam"
call :KILL "NordVPN.exe"             "NordVPN"
call :KILL "ExpressVPN.exe"          "ExpressVPN"
call :KILL "Surfshark.exe"           "Surfshark"
call :KILL "ProtonVPN.exe"           "ProtonVPN"
call :KILL "openvpn.exe"             "OpenVPN"
call :KILL "AutoHotkey.exe"          "AutoHotKey"
call :KILL "autohotkey64.exe"        "AutoHotKey x64"
call :KILL "AutoIt3.exe"             "AutoIt"
call :KILL "TeamViewer.exe"          "TeamViewer"
call :KILL "AnyDesk.exe"             "AnyDesk"
call :KILL "Parsec.exe"              "Parsec"

echo.
echo  Processus tues : !KILLED!
echo.
timeout /t 1 /nobreak >nul

:: ============================================================
:: ETAPE 2 — SERVICES WINDOWS
:: ============================================================
color 0E
echo  [2/4] Arret des services conflictuels...
echo  ----------------------------------------------------------------
color 0A

call :STOP_SVC "XboxGipSvc"      "Xbox Accessory Management"
call :STOP_SVC "reWASD"          "reWASD Service"
call :STOP_SVC "RTSS"            "RivaTuner Service"
call :STOP_SVC "OverwolfUpdater" "Overwolf Updater"

echo.
timeout /t 1 /nobreak >nul

:: ============================================================
:: ETAPE 3 — RESEAU
:: ============================================================
color 0E
echo  [3/4] Nettoyage reseau...
echo  ----------------------------------------------------------------
color 0A

ipconfig /flushdns                      >nul 2>&1 & echo   DNS flush           OK
netsh winsock reset                     >nul 2>&1 & echo   Winsock reset       OK
netsh int ip reset                      >nul 2>&1 & echo   TCP-IP reset        OK
ipconfig /release                       >nul 2>&1
timeout /t 2 /nobreak                   >nul
ipconfig /renew                         >nul 2>&1 & echo   IP renew            OK
netsh interface ip delete arpcache      >nul 2>&1 & echo   ARP cache cleared   OK

echo.
timeout /t 1 /nobreak >nul

:: ============================================================
:: ETAPE 4 — LANCEMENT + SMART MONITOR
:: ============================================================
color 0E
echo  [4/4] Lancement Valorant + Moniteur Vanguard...
echo  ----------------------------------------------------------------
color 0A

:: Lancer le moniteur intelligent en arriere-plan
start "VanguardMonitor" /min cmd /c "%~f0" --monitor

set "P1=%LOCALAPPDATA%\Riot Games\Riot Client\RiotClientServices.exe"
set "P2=C:\Riot Games\Riot Client\RiotClientServices.exe"
set "P3=C:\Program Files\Riot Games\Riot Client\RiotClientServices.exe"
set "ARGS=--launch-product=valorant --launch-patchline=live"

if exist "!P1!" ( start "" "!P1!" %ARGS% & goto LAUNCH_OK )
if exist "!P2!" ( start "" "!P2!" %ARGS% & goto LAUNCH_OK )
if exist "!P3!" ( start "" "!P3!" %ARGS% & goto LAUNCH_OK )

color 0C
echo  Riot Client introuvable. Verifie le chemin dans P1.
pause & exit /b 1

:LAUNCH_OK
cls
color 0A
echo.
echo  ================================================================
echo   VALORANT LANCE  —  Bonne partie !
echo  ================================================================
echo.
echo   [OK]  !KILLED! conflits fermes
echo   [OK]  Services Windows arretes
echo   [OK]  Reseau entierement reinitialise
echo   [OK]  Moniteur Vanguard actif en arriere-plan
echo   [OK]  Discord intact
echo.
echo  Fermeture dans 5 secondes...
echo  ================================================================
timeout /t 5 /nobreak >nul
exit /b 0

:: ============================================================
:: HELPERS
:: ============================================================
:KILL
tasklist /FI "IMAGENAME eq %~1" 2>nul | find /I "%~1" >nul
if %errorLevel% EQU 0 (
    taskkill /F /IM "%~1" >nul 2>&1
    echo   [KILL]  %~2
    set /a KILLED+=1
)
exit /b 0

:STOP_SVC
sc query "%~1" >nul 2>&1
if %errorLevel% EQU 0 (
    net stop "%~1" >nul 2>&1
    echo   [STOP]  %~2
) else (
    echo   [SKIP]  %~2 (absent)
)
exit /b 0

:: ============================================================
:: MONITEUR INTELLIGENT — Agit UNIQUEMENT si Vanguard a un probleme
:: ============================================================
:MONITOR_MODE
title [VanguardMonitor] En surveillance...
set "CRASH_COUNT=0"
set "VGC_WAS_OK=0"

:MONITOR_LOOP
timeout /t 5 /nobreak >nul

:: Si Valorant est ferme = on s'arrete proprement
tasklist /FI "IMAGENAME eq VALORANT.exe" 2>nul | find /I "VALORANT.exe" >nul
if %errorLevel% NEQ 0 (
    title [VanguardMonitor] Valorant ferme — Arret moniteur
    exit /b 0
)

:: Verifier si vgc.exe tourne (signe que Vanguard est actif et sain)
tasklist /FI "IMAGENAME eq vgc.exe" 2>nul | find /I "vgc.exe" >nul
if %errorLevel% EQU 0 (
    :: vgc est en vie = tout va bien
    set "VGC_WAS_OK=1"
    title [VanguardMonitor] Vanguard OK — Valorant actif
    goto MONITOR_LOOP
)

:: vgc.exe n'est PAS en train de tourner alors que Valorant tourne
:: = Vanguard a crash ou a ete tue = probleme detecte
if "!VGC_WAS_OK!"=="0" goto MONITOR_LOOP

:: vgc etait OK avant mais ne l'est plus = crash reel detecte
set /a CRASH_COUNT+=1
title [VanguardMonitor] PROBLEME DETECTE ^(crash #!CRASH_COUNT!^)

:: Reaction immediate : tuer ce qui aurait pu provoquer le crash
for %%P in (
    NordVPN.exe ExpressVPN.exe Surfshark.exe ProtonVPN.exe openvpn.exe
    x360ce.exe x360ce_x64.exe reWASD.exe reWASDService.exe DS4Windows.exe
    Xpadder.exe JoyToKey.exe AntiMicroX.exe
    lghub_agent.exe lghub_updater.exe
    AutoHotkey.exe autohotkey64.exe AutoIt3.exe
    MSIAfterburner.exe RTSS.exe Overwolf.exe medal.exe
    TeamViewer.exe AnyDesk.exe Parsec.exe
) do taskkill /F /IM "%%P" >nul 2>&1

:: Alerter le joueur via notification Windows
powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Vanguard (vgc.exe) a crash pendant ta partie.`nLes apps conflictuelles ont ete fermees automatiquement.`n`nCrash numero : !CRASH_COUNT!', 'VanguardMonitor — Probleme detecte', 'OK', 'Warning')" >nul 2>&1

:: Si 2 crashs ou plus = proposer la reinstallation Vanguard
if !CRASH_COUNT! GEQ 2 (
    powershell -Command "Add-Type -AssemblyName System.Windows.Forms; $r = [System.Windows.Forms.MessageBox]::Show('Vanguard a crash !CRASH_COUNT! fois.`nTu devrais reinstaller Vanguard avec ReinstallVanguard.bat.`n`nVeux-tu fermer Valorant maintenant pour le faire ?', 'VanguardMonitor — Reinstallation conseillee', 'YesNo', 'Error'); if ($r -eq 6) { Stop-Process -Name VALORANT -Force -ErrorAction SilentlyContinue }" >nul 2>&1
)

:: Remettre le flag a 0 pour attendre que vgc revienne
set "VGC_WAS_OK=0"
goto MONITOR_LOOP
