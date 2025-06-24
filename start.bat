@echo off
setlocal enabledelayedexpansion

echo 🔄 Mise à jour du dépôt Git en cours (force overwrite)...

:: Vérification de git
where git >nul 2>&1
if errorlevel 1 (
    echo ⚠️ git n'est pas installé. Impossible de faire la mise à jour.
) else (
    git fetch origin
    for /f "tokens=*" %%i in ('git rev-parse --abbrev-ref HEAD') do set BRANCH=%%i
    git reset --hard origin/%BRANCH%
    echo ✅ Mise à jour terminée.
)

echo ▶️ Lancement du serveur Node.js...
node www/server.js
pause
