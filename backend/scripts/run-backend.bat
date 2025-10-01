@echo off
cd /d %~dp0\..
poetry run uvicorn app.main:app --reload
pause
