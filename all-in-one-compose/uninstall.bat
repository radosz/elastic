@echo off
:: Navigate to the directory of this script (in case it's run from elsewhere)
cd /d "%~dp0"

:: Run docker-compose down -v
echo Stopping and removing containers...
docker-compose down -v

:: Run the rollback_hosts script
echo Rolling back host changes...
call helpers/rollback_hosts.bat

echo Uninstall completed.
pause
