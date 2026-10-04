@echo off
title LibreTranslate SS13
cd /d "%~dp0"
echo Starting LibreTranslate (RU <-> EN)...
venv\Scripts\python.exe start_translate.py
pause
