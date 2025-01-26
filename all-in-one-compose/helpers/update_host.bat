@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: Path to the Windows hosts file
SET HOSTS_PATH=C:\Windows\System32\drivers\etc\hosts

:: Backup the current hosts file
IF NOT EXIST "%HOSTS_PATH%.bak" (
    echo Backing up hosts file to "%HOSTS_PATH%.bak"...
    copy "%HOSTS_PATH%" "%HOSTS_PATH%.bak" > NUL
)

:: Temporary file for Docker container information
SET TEMP_FILE=%TEMP%\docker_containers.txt

:: Remove old Docker-related entries from the hosts file
echo Removing old Docker entries from hosts file...
findstr /v "# Docker Container:" "%HOSTS_PATH%" > "%HOSTS_PATH%.tmp"
move /Y "%HOSTS_PATH%.tmp" "%HOSTS_PATH%" > NUL

:: Fetch all running Docker containers and their hostnames
echo Fetching Docker container hostnames...
docker ps --format "{{.Names}}" > "%TEMP_FILE%"

:: Append Docker container hostnames to the hosts file with 127.0.0.1
FOR /F %%i IN ('type "%TEMP_FILE%"') DO (
    echo Adding hostname '%%i' with IP '127.0.0.1'...
    echo # Docker Container: %%i >> "%HOSTS_PATH%"
    echo 127.0.0.1 %%i >> "%HOSTS_PATH%"
)

:: Clean up temporary file
del "%TEMP_FILE%"
echo Hosts file updated successfully!
ENDLOCAL
