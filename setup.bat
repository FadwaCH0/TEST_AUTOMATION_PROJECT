@echo off
echo ========================================
echo  Configuration du projet de test
echo ========================================

REM Aller au dossier du script
cd /d "%~dp0"

REM Verifier Python
python --version > nul 2>&1
if errorlevel 1 (
    echo ERREUR: Python n'est pas installe ou pas dans le PATH
    echo Installez Python depuis https://python.org
    pause
    exit /b 1
)

REM Verifier Node.js
node --version > nul 2>&1
if errorlevel 1 (
    echo ERREUR: Node.js n'est pas installe ou pas dans le PATH
    echo Installez Node.js depuis https://nodejs.org
    pause
    exit /b 1
)

REM Creer l'environnement virtuel Python
echo Creation de l'environnement virtuel Python...
if exist "robot-env" (
    echo Suppression de l'ancien environnement virtuel...
    rmdir /s /q robot-env
)

python -m venv robot-env
if errorlevel 1 (
    echo ERREUR: Impossible de creer l'environnement virtuel
    pause
    exit /b 1
)

REM Activer l'environnement virtuel
call robot-env\Scripts\activate.bat

REM Installer les dependances Robot Framework
echo Installation des dependances Robot Framework...
pip install --upgrade pip
pip install robotframework
pip install robotframework-seleniumlibrary
pip install robotframework-requests
pip install webdriver-manager

REM Installer les dependances backend
echo Installation des dependances backend...
cd backend
npm install
if errorlevel 1 (
    echo ERREUR: Impossible d'installer les dependances backend
    pause
    exit /b 1
)
cd ..

REM Installer les dependances frontend
echo Installation des dependances frontend...
cd frontend
npm install
if errorlevel 1 (
    echo ERREUR: Impossible d'installer les dependances frontend
    pause
    exit /b 1
)
cd ..

REM Creer les dossiers necessaires
if not exist "tests\robot\results" mkdir tests\robot\results

echo ========================================
echo  Configuration terminee avec succes!
echo ========================================
echo.
echo Prochaines etapes:
echo 1. Lancez 'run_tests.bat' pour executer tous les tests
echo 2. Ou lancez 'run_api_tests.bat' pour les tests API uniquement
echo 3. Ou lancez 'run_ui_tests.bat' pour les tests UI uniquement
echo.
pause