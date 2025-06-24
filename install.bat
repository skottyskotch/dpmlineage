@echo off
setlocal enabledelayedexpansion

echo 🔧 Installation du projet...

:: Vérification Python 3
where python >nul 2>&1
if errorlevel 1 (
    echo ❌ Python n'est pas installé. Merci de l'installer avant.
    exit /b 1
)

:: Création du venv s'il n'existe pas
if not exist venv (
    echo 📦 Création de l'environnement virtuel Python...
    python -m venv venv
)

:: Activation du venv
call venv\Scripts\activate.bat

echo 📚 Installation des dépendances Python...
pip install --upgrade pip
pip install -r requirements.txt

:: Vérification de git
where git >nul 2>&1
if errorlevel 1 (
    echo ⚠️ git n'est pas installé. Merci de l'installer avant.
    exit /b 1
) else (
    echo ✅ git est installé.
)

:: Vérification de node et npm
where node >nul 2>&1
where npm >nul 2>&1
if errorlevel 1 (
    echo ⚠️ Node.js ou npm non trouvés. Merci de les installer avant.
    exit /b 1
) else (
    echo ✅ Node.js et npm sont installés.
)

:: Installation des dépendances Node.js
if exist www\package.json (
    echo 📦 Installation des dépendances Node.js dans www...
    pushd www
    npm install
    popd
) else (
    echo ⚠️ Aucun fichier www\package.json trouvé.
)

echo ✅ Installation terminée avec succès !
pause
