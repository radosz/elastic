@echo off
echo =============================================
echo Displaying all open ports on the host system
echo =============================================
netstat -ano | findstr LISTENING
echo.

echo =============================================
echo Displaying Docker container open ports
echo =============================================
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}"
echo.

echo Complete.
pause