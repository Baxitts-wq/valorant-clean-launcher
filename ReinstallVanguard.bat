@echo off
setlocal enabledelayedexpansion

:: ============================================================
:: Auto-elevation — echo outside if block to prevent
:: the ) in CreateObject() from being misread by batch parser
:: ============================================================
if "%1"=="ELEVATED" goto MAIN

echo Set UAC = CreateObject("Shell.Application") > "%temp%\elev.vbs"
echo UAC.ShellExecute "%~s0", "ELEVATED", "", "runas", 1 >> "%temp%\elev.vbs"
"%temp%\elev.vbs"
del "%temp%\elev.vbs" >nul 2>&1
exit /b

:MAIN
:: ============================================================
:: SCRIPT START (admin rights confirmed)
:: ============================================================
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
echo    2. Stop vgc and vgk services
echo    3. Run sc delete vgc and sc delete vgk
echo    4. Clean leftover registry entries
echo    5. Restart your PC
echo.
color 0E
echo  Save everything you have open before continuing.
echo  Your PC will restart automatically at the end.
echo.
color 0A
echo  Press any key to start...
pause >nul

:: ============================================================
:: STEP 1 — Delete vgkbootstatus.dat
:: ============================================================
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

:: ============================================================
:: STEP 2 — Stop Vanguard processes and services
:: ============================================================
echo.
echo  [2/4] Stopping Vanguard services and processes...

net stop vgc >nul 2>&1
net stop vgk >nul 2>&1
taskkill /F /IM "vgtray.exe"              >nul 2>&1
taskkill /F /IM "vgc.exe"                >nul 2>&1
taskkill /F /IM "vgk.exe"                >nul 2>&1
taskkill /F /IM "RiotClientServices.exe"  >nul 2>&1
taskkill /F /IM "RiotClientUx.exe"        >nul 2>&1

echo  [OK] Done.

:: ============================================================
:: STEP 3 — sc delete vgc / vgk + registry cleanup
:: ============================================================
echo.
echo  [3/4] Deleting services (sc delete)...

sc delete vgc >nul 2>&1
echo  [OK] sc delete vgc
sc delete vgk >nul 2>&1
echo  [OK] sc delete vgk

reg delete "HKLM\SYSTEM\CurrentControlSet\Services\vgc" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\vgk" /f >nul 2>&1
echo  [OK] Registry cleaned.

:: ============================================================
:: STEP 4 — Restart
:: ============================================================
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

for /L %%i in (15,-1,1) do (
    title  VANGUARD REINSTALL — Restarting in %%i sec...
    timeout /t 1 /nobreak >nul
)

shutdown /r /t 0 /c "Vanguard Reinstall"
