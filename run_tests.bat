@echo off
echo ========================================
echo  Tests Robot Framework - Version Amelioree
echo ========================================

cd /d "%~dp0"

REM Verifier et activer l'environnement virtuel
if not exist "robot-env\Scripts\activate.bat" (
    echo ERREUR: Environnement virtuel non trouve. Executez setup.bat d'abord.
    pause
    exit /b 1
)

call robot-env\Scripts\activate.bat

REM Arreter tous les processus Node.js existants pour eviter les conflits
echo Arret des processus Node.js existants...
taskkill /F /IM node.exe /T > nul 2>&1

REM Demarrer le backend
echo Demarrage du backend...
cd backend
start "Backend Server" cmd /k "npm start"
cd ..

REM Attendre le backend avec verification
echo Verification du backend...
timeout /t 5 /nobreak > nul

:check_backend
curl -f http://localhost:5000/health > nul 2>&1
if errorlevel 1 (
    echo Attente du backend...
    timeout /t 2 /nobreak > nul
    goto check_backend
)
echo Backend OK!

REM Demarrer le frontend
echo Demarrage du frontend...
cd frontend
start "Frontend Server" cmd /k "npm run dev"
cd ..

REM Attendre le frontend avec verification
echo Verification du frontend...
timeout /t 10 /nobreak > nul

:check_frontend
curl -f http://localhost:5173 > nul 2>&1
if errorlevel 1 (
    echo Attente du frontend...
    timeout /t 3 /nobreak > nul
    goto check_frontend
)
echo Frontend OK!

REM Creer le dossier de resultats
if not exist "tests\results" mkdir tests\results

REM Mettre a jour ChromeDriver
echo Mise a jour de ChromeDriver...
python -c "from webdriver_manager.chrome import ChromeDriverManager; ChromeDriverManager().install()" > nul 2>&1

echo ========================================
echo  Execution des tests
echo ========================================

REM Option pour choisir les tests
echo Choisissez les tests a executer:
echo 1. Tests API uniquement
echo 2. Tests UI uniquement  
echo 3. Tous les tests
echo 4. Tests smoke uniquement
set /p choice="Votre choix (1-4): "

if "%choice%"=="1" (
    echo Execution des tests API...
    robot --outputdir tests\results --include api tests\api\
    goto end_tests
)

if "%choice%"=="2" (
    echo Execution des tests UI...
    robot --outputdir tests\results --include ui --variable HEADLESS:False tests\ui\
    goto end_tests
)

if "%choice%"=="3" (
    echo Execution de tous les tests...
    robot --outputdir tests\results tests\
    goto end_tests
)

if "%choice%"=="4" (
    echo Execution des tests smoke...
    robot --outputdir tests\results --include smoke tests\
    goto end_tests
)

echo Choix invalide, execution de tous les tests par defaut...
robot --outputdir tests\results tests\

:end_tests
set TEST_EXIT_CODE=%errorlevel%

echo ========================================
echo  Resultats
echo ========================================

if %TEST_EXIT_CODE%==0 (
    echo SUCCES: Tous les tests sont passes!
) else (
    echo ECHEC: Certains tests ont echoue.
)

echo.
echo Rapports generes:
echo - Rapport HTML: tests\results\report.html
echo - Log detaille: tests\results\log.html
echo - Resultats XML: tests\results\output.xml

REM Ouvrir automatiquement le rapport si les tests sont termines
set /p open_report="Ouvrir le rapport HTML? (o/n): "
if /i "%open_report%"=="o" (
    start tests\results\report.html
)

echo.
echo Arret des serveurs...
taskkill /F /IM node.exe /T > nul 2>&1

echo.
echo Terminé!
pause