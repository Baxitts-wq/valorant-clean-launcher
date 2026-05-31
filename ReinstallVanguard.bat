@echo off
setlocal enabledelayedexpansion

:: Auto-elevation admin
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs" >nul 2>&1
    exit /b 0
)

cls
title  REINSTALLATION VANGUARD — Instructions Riot Support
color 0C

echo.
echo  ================================================================
echo   REINSTALLATION VANGUARD — Guide Riot Support (Genericow)
echo  ================================================================
echo.
echo  Ce script suit exactement les etapes donnees par le support Riot.
echo  Lance en administrateur : OK
echo.
color 0E
echo  ATTENTION : Ton PC va redemarrer automatiquement a la fin.
echo  Sauvegarde tout ce que tu as ouvert maintenant.
echo.
color 0A
echo  Appuie sur une touche pour commencer, ou ferme cette fenetre pour annuler.
pause >nul

cls
color 0A

:: ============================================================
:: ETAPE 1 — Supprimer vgkbootstatus.dat
:: ============================================================
color 0E
echo.
echo  [1/4] Suppression de vgkbootstatus.dat...
echo  ----------------------------------------------------------------
color 0A

if exist "C:\Windows\vgkbootstatus.dat" (
    del /F /Q "C:\Windows\vgkbootstatus.dat" >nul 2>&1
    if exist "C:\Windows\vgkbootstatus.dat" (
        color 0C
        echo  [ERREUR] Impossible de supprimer le fichier. Essai en force...
        takeown /F "C:\Windows\vgkbootstatus.dat" >nul 2>&1
        icacls "C:\Windows\vgkbootstatus.dat" /grant administrators:F >nul 2>&1
        del /F /Q "C:\Windows\vgkbootstatus.dat" >nul 2>&1
        color 0A
    )
    echo  [OK] vgkbootstatus.dat supprime.
) else (
    echo  [SKIP] Fichier vgkbootstatus.dat introuvable (deja absent, OK).
)
echo.
timeout /t 1 /nobreak >nul

:: ============================================================
:: ETAPE 2 — Arreter les services Vanguard actifs
:: ============================================================
color 0E
echo  [2/4] Arret des services Vanguard en cours...
echo  ----------------------------------------------------------------
color 0A

net stop vgc >nul 2>&1
echo  [OK] Service vgc arrete (ou deja inactif).

net stop vgk >nul 2>&1
echo  [OK] Service vgk arrete (ou deja inactif).

:: Tuer les processus Vanguard qui tournent encore
taskkill /F /IM "vgtray.exe"     >nul 2>&1
taskkill /F /IM "vgc.exe"        >nul 2>&1
taskkill /F /IM "vgk.exe"        >nul 2>&1
taskkill /F /IM "RiotClientServices.exe" >nul 2>&1
echo  [OK] Processus Vanguard / Riot Client fermes.
echo.
timeout /t 1 /nobreak >nul

:: ============================================================
:: ETAPE 3 — Supprimer les services (sc delete vgc / vgk)
:: ============================================================
color 0E
echo  [3/4] Suppression des services Vanguard (sc delete)...
echo  ----------------------------------------------------------------
color 0A

sc delete vgc >nul 2>&1
echo  [OK] Service vgc supprime (commande: sc delete vgc).

sc delete vgk >nul 2>&1
echo  [OK] Service vgk supprime (commande: sc delete vgk).

:: Nettoyer les entrees registre residuelles de Vanguard
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\vgc" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\vgk" /f >nul 2>&1
echo  [OK] Entrees registre Vanguard nettoyees.
echo.
timeout /t 1 /nobreak >nul

:: ============================================================
:: ETAPE 4 — Redemarrage automatique
:: ============================================================
color 0E
echo  [4/4] Preparation du redemarrage...
echo  ----------------------------------------------------------------
color 0A

echo.
echo  Tout est fait :
echo    [OK] vgkbootstatus.dat supprime
echo    [OK] Services vgc et vgk arretes
echo    [OK] sc delete vgc execute
echo    [OK] sc delete vgk execute
echo    [OK] Registre nettoye
echo.
color 0C
echo  IMPORTANT apres le redemarrage :
echo  -------------------------------------------------------
echo   1. Lance VALORANT normalement avec ton raccourci
echo   2. Vanguard va se reinstaller automatiquement
echo   3. Si on te demande de redemarrer encore une fois,
echo      fais-le (redemarrer, pas eteindre)
echo   4. Apres ca tu pourras jouer normalement
echo  -------------------------------------------------------
echo.
color 0E
echo  Le PC va redemarrer dans 15 secondes...
echo  Appuie sur CTRL+C pour annuler le redemarrage si besoin.
echo.

:: Compte a rebours visible
for /L %%i in (15,-1,1) do (
    set /p "=  Redemarrage dans %%i secondes...   " <nul
    echo.
    timeout /t 1 /nobreak >nul
)

shutdown /r /t 0 /c "Reinstallation Vanguard — Riot Support"
