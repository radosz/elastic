@echo off
REM This script sets up port forwarding for Docker containers using netsh portproxy

REM Ensure delayed expansion is enabled
setlocal enabledelayedexpansion

REM Retrieve container names and their ports
FOR /F "tokens=1,* delims= " %%A IN ('docker ps --format "{{.Names}} {{.Ports}}"') DO (
    REM Parse name and ports
    SET CONTAINER_NAME=%%A
    SET CONTAINER_PORT_RAW=%%B

    REM Check if there is a port mapping
    IF NOT "!CONTAINER_PORT_RAW!"=="" (
        REM Find and clean up the host port
        REM Remove any unwanted substrings like "0.0.0.0:" or "/tcp"
        REM Also stop at "->" to get only the left-hand side of the mapping
        FOR %%P IN (!CONTAINER_PORT_RAW!) DO (
            REM Remove "0.0.0.0:"
            SET HOST_PORT=%%P
            SET HOST_PORT=!HOST_PORT:0.0.0.0:=!
            SET HOST_PORT=!HOST_PORT:127.0.0.1:=!
            REM Remove "/tcp"
            SET HOST_PORT=!HOST_PORT:/tcp=!
            REM Remove everything after "->"
            FOR /F "tokens=1 delims=->" %%Q IN ("!HOST_PORT!") DO SET HOST_PORT=%%Q
            REM Use only the first port if multiple exist (e.g., "9200,9300")
            FOR /F "tokens=1 delims=," %%R IN ("!HOST_PORT!") DO SET HOST_PORT=%%R
        )
        echo !CONTAINER_NAME!:!HOST_PORT!
        rem netsh interface portproxy add v4tov4 listenaddress=!CONTAINER_NAME! listenport=!HOST_PORT! connectaddress=127.0.0.1 connectport=!HOST_PORT!
    )
)

REM End the script
endlocal
