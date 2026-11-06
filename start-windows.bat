@echo off
setlocal
cd /d "%~dp0"
where node >nul 2>nul
if errorlevel 1 (
  echo Node.js 18 or newer is required. Install it from https://nodejs.org/
  pause
  exit /b 1
)
start "ResQFlow local server" cmd /k node server.js
timeout /t 2 /nobreak >nul
start "" http://localhost:3000
