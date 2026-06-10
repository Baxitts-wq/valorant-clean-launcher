@echo off
setlocal enabledelayedexpansion

if "%1"=="ELEVATED" goto MAIN

echo Set UAC = CreateObject("Shell.Application") > "%temp%\elev.vbs"
echo UAC.ShellExecute "%~s0", "ELEVATED", "", "runas", 1 >> "%temp%\elev.vbs"
"%temp%\elev.vbs"
del "%temp%\elev.vbs" >nul 2>&1
exit /b

:MAIN
cls
title  VANGUARD REINSTALL
color 0C
echo.
echo  ================================================================
echo   VANGUARD REINSTALL  —  Riot Support Fix
echo  ================================================================
echo.
echo  This script will :
echo    1. Delete vgkbootstatus.dat
echo    2. Kill Riot and Vanguard software tasks
echo    3. Remove vgc/vgk registry keys and system services
echo    4. Force a clean restart of your PC
echo.
color 0E
echo  Save everything you have open before continuing.
echo  Your PC will restart automatically at the end.
echo.
color 0A
echo  Press any key to start...
pause >nul

cls
echo.
echo  [1/4] Deleting vgkbootstatus.dat...

if exist "C:\Windows\vgkbootstatus.dat" (
    takeown /F "C:\Windows\vgkbootstatus.dat" >nul 2>&1
    icacls "C:\Windows\vgkbootstatus.dat" /grant administrators:F >nul 2>&1
    del /F /Q "C:\Windows\vgkbootstatus.dat" >nul 2>&1
    if exist "C:\Windows\vgkbootstatus.dat" (
        echo  [ERROR] Could not delete the file.
    ) else (
        echo  [OK] Deleted.
    )
) else (
    echo  [OK] File already gone.
)

echo.
echo  [2/4] Killing running Riot and Vanguard tasks...

taskkill /F /IM "vgtray.exe"              >nul 2>&1
taskkill /F /IM "RiotClientServices.exe"  >nul 2>&1
taskkill /F /IM "RiotClientUx.exe"        >nul 2>&1
taskkill /F /IM "vgc.exe"                >nul 2>&1
net stop vgc >nul 2>&1

echo  [OK] Tasks stopped.

echo.
echo  [3/4] Stripping service properties and cleaning registry...

sc delete vgc >nul 2>&1
echo  [OK] sc delete vgc
sc delete vgk >nul 2>&1
echo  [OK] sc delete vgk

reg delete "HKLM\SYSTEM\CurrentControlSet\Services\vgc" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\vgk" /f >nul 2>&1
echo  [OK] Registry cleaned.

echo.
echo  [4/4] All done.
echo.
color 0E
echo  -------------------------------------------------------
echo  AFTER RESTART :
echo    - Launch Valorant normally
echo    - Vanguard will reinstall itself automatically
echo    - If it asks you to restart again, do it
echo      ^(Restart, NOT Shut down^)
echo  -------------------------------------------------------
echo.
color 0A
echo  Restarting your PC in 10 seconds. Press Ctrl+C to abort...
timeout /t 10
shutdown /r /t 0 /c "Vanguard Reinstall"
