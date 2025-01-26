@echo off
:: Navigate to the directory of this script (in case it's run from elsewhere)
cd /d "%~dp0"

:: Check for admin privileges
openfiles > nul 2>&1
if %errorlevel%==0 (
    goto start
) else (
    echo This script requires admin privileges to run. Please run as administrator.
    pause
    exit
)

:start
:: Run docker-compose up -d
docker-compose up -d

:: Run the update_host script with admin privileges
call helpers/update_host.bat

echo Script completed.
pause