@echo off
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Run this as Administrator
    pause
    exit /b 1
)

if "%1"=="--watch" goto WATCH

title Valorant Launcher
color 0A

echo.
echo  Closing conflicting apps...
echo.

taskkill /F /IM "steam.exe" >nul 2>&1
taskkill /F /IM "steamwebhelper.exe" >nul 2>&1
taskkill /F /IM "GameOverlayUI.exe" >nul 2>&1
taskkill /F /IM "EpicGamesLauncher.exe" >nul 2>&1
taskkill /F /IM "EpicWebHelper.exe" >nul 2>&1
taskkill /F /IM "Discord.exe" >nul 2>&1
taskkill /F /IM "DiscordPTB.exe" >nul 2>&1
taskkill /F /IM "lghub.exe" >nul 2>&1
taskkill /F /IM "lghub_agent.exe" >nul 2>&1
taskkill /F /IM "lghub_updater.exe" >nul 2>&1
taskkill /F /IM "LogiOptions.exe" >nul 2>&1
taskkill /F /IM "Xpadder.exe" >nul 2>&1
taskkill /F /IM "x360ce.exe" >nul 2>&1
taskkill /F /IM "reWASD.exe" >nul 2>&1
taskkill /F /IM "JoyToKey.exe" >nul 2>&1
taskkill /F /IM "AntiMicroX.exe" >nul 2>&1
taskkill /F /IM "MSIAfterburner.exe" >nul 2>&1
taskkill /F /IM "RTSS.exe" >nul 2>&1
taskkill /F /IM "obs64.exe" >nul 2>&1
taskkill /F /IM "obs32.exe" >nul 2>&1

echo  Done.
echo.
echo  Fixing network...

ipconfig /flushdns >nul 2>&1
netsh winsock reset >nul 2>&1
netsh int ip reset >nul 2>&1
ipconfig /release >nul 2>&1
timeout /t 2 /nobreak >nul
ipconfig /renew >nul 2>&1

echo  Done.
echo.

start "Vanguard Monitor" /min cmd /c "%~f0" --watch

set "P1=%LOCALAPPDATA%\Riot Games\Riot Client\RiotClientServices.exe"
set "P2=C:\Riot Games\Riot Client\RiotClientServices.exe"
set "ARGS=--launch-product=valorant --launch-patchline=live"

if exist "%P1%" (
    start "" "%P1%" %ARGS%
    goto DONE
)
if exist "%P2%" (
    start "" "%P2%" %ARGS%
    goto DONE
)

echo  Riot Client not found. Edit P1 in this script with your install path.
pause
exit /b 1

:DONE
echo  All good, launching Valorant...
timeout /t 3 /nobreak >nul
exit /b 0

:WATCH
:LOOP
timeout /t 30 /nobreak >nul
tasklist /FI "IMAGENAME eq VALORANT.exe" 2>nul | find /I "VALORANT.exe" >nul
if %errorLevel% NEQ 0 exit /b 0

taskkill /F /IM "steam.exe" >nul 2>&1
taskkill /F /IM "GameOverlayUI.exe" >nul 2>&1
taskkill /F /IM "Discord.exe" >nul 2>&1
taskkill /F /IM "lghub_agent.exe" >nul 2>&1
taskkill /F /IM "lghub_updater.exe" >nul 2>&1
taskkill /F /IM "x360ce.exe" >nul 2>&1
taskkill /F /IM "reWASD.exe" >nul 2>&1
taskkill /F /IM "RTSS.exe" >nul 2>&1
taskkill /F /IM "MSIAfterburner.exe" >nul 2>&1

goto LOOP
