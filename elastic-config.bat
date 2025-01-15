@echo off
setlocal
setlocal enabledelayedexpansion

:: Check if an argument was passed
if "%~1"=="" (
    echo Error: No arguments provided. Use --dock or --loc.
    exit /b 1
)

:: Check if the script is running with --dock argument
if "%~1"=="--dock" goto :dock

:: Check if the script is running with --loc argument
if "%~1"=="--loc" goto :loc

:: Invalid argument
echo Error: Invalid argument. Use --dock or --loc.
exit /b 1

:dock
:: Get list of Elasticsearch container names starting with "es" and their respective IDs
for /f "tokens=*" %%A in ('docker ps --format "{{.Names}}" ^| findstr "es"') do ( 
    rem :: Check if the container name matches the desired format (esXX-X)
    rem echo %%A | findstr /r "^es[0-9][0-9]*-[0-9]*$"
    if not errorlevel 1 (
        :: Copy the elasticsearch.yml file from the container
        docker cp %%A:/usr/share/elasticsearch/config/elasticsearch.yml . >nul 2>&1
        if errorlevel 1 (
            echo Failed to copy configuration file from container %%A. Check if the file exists or permission issues.
        ) else (
            :: Rename the copied file
            rename elasticsearch.yml elasticsearch-%%A.yml
            echo Successfully copied and renamed elasticsearch.yml from %%A
        )
    ) 
)

exit /b 0

:loc
:: Check if the local directory contains configuration files for known containers
for %%A in (elasticsearch-*-?.yml) do (
    echo Found file: %%A

    :: Extract the container name from the filename
    set "ContainerName=%%~nA"
    set "ContainerName=!ContainerName:elasticsearch-=!"
    set "ContainerName=!ContainerName:.=!"

    :: Attempt to copy the file, handling potential errors
    docker cp %%A !ContainerName!:/usr/share/elasticsearch/config/elasticsearch.yml >nul 2>&1
    if !errorlevel! equ 0 (
        echo Successfully copied %%A to !ContainerName!.
    ) else (
        echo Error copying %%A to container !ContainerName!. Check if the container is running.
        exit /b 1
    )
)
exit /b 0