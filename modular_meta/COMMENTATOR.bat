@echo off
chcp 65001 > nul
title Code Commentator

python -c "import git" 2>nul
if %errorlevel% neq 0 (
    echo Library 'GitPython' is missing. Installing...
    pip install GitPython --quiet
    echo.
)

echo =======================================================================================================================
echo                                                    Setup Commentator
echo =======================================================================================================================
echo.

set "MODPACK=none"
set /p "MODPACK=Enter modpack name. Proceed for default nothing: "

echo.
echo ---------------------------------------------------
echo Running python script with parameters...
echo Modpack: %MODPACK%
echo ---------------------------------------------------
echo.

python tools\\commentator.py "%MODPACK%"

echo.
echo Operation finished.
pause
