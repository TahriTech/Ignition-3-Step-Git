@echo off
REM =============================================================================
REM commit-changes-windows.bat - Save Ignition changes to Git (WINDOWS ONLY)
REM =============================================================================
REM 
REM What this does:
REM   1. Saves changes in the data/ folder to Git
REM   2. Logs everything to data/git-commits.log
REM   3. Returns 0 if successful, 1 if failed
REM
REM Place this file in the ROOT of your Ignition installation folder
REM Example: C:\Program Files\Inductive Automation\Ignition\commit-changes-windows.bat
REM
REM Usage from command line:
REM   commit-changes-windows.bat "Your message here"
REM
REM Usage from Ignition Gateway Script:
REM   system.util.execute(["commit-changes-windows.bat", "Your message"])
REM
REM =============================================================================

setlocal enabledelayedexpansion

REM Go to the folder where this script is located (Ignition root)
cd /d "%~dp0"

REM Get the message (or create one with timestamp if not provided)
if "%~1"=="" (
    for /f "tokens=1-4 delims=/ " %%a in ('date /t') do (set MYDATE=%%c-%%a-%%b)
    for /f "tokens=1-2 delims=: " %%a in ('time /t') do (set MYTIME=%%a:%%b)
    set "MESSAGE=Auto save !MYDATE! !MYTIME!"
) else (
    set "MESSAGE=%~1"
)

REM Create log file if needed
set "LOG=data\git-commits.log"
if not exist "%LOG%" (
    echo Git Commit Log > "%LOG%"
    echo ============== >> "%LOG%"
)

REM Log what we're doing
echo. >> "%LOG%"
echo [%date% %time%] Saving: %MESSAGE% >> "%LOG%"

REM Check if Git is installed
where git >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Git not found. Install Git first. >> "%LOG%"
    echo ERROR: Git not found. Install Git first.
    exit /b 1
)

REM Check if Git is set up
if not exist ".git" (
    echo ERROR: Not a Git repo. Run 'git init' first. >> "%LOG%"
    echo ERROR: Not a Git repo. Run 'git init' first.
    exit /b 1
)

REM Add all changes in data/ folder (relative path)
git add data/ >> "%LOG%" 2>&1

REM Check if anything actually changed
git diff --cached --quiet
if %ERRORLEVEL% EQU 0 (
    echo INFO: Nothing changed, nothing to save >> "%LOG%"
    echo INFO: Nothing changed, nothing to save
    exit /b 0
)

REM Save the changes
git commit -m "%MESSAGE%" >> "%LOG%" 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Save failed >> "%LOG%"
    echo ERROR: Save failed
    exit /b 1
)

echo SUCCESS: Changes saved to Git >> "%LOG%"
echo SUCCESS: Changes saved to Git

REM Optional: Uncomment these lines to auto-push to GitHub/GitLab
REM git push >> "%LOG%" 2>&1

exit /b 0
