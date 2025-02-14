@echo off
setlocal EnableDelayedExpansion

set "ENV_FILE=../.env"

echo "Extract env vars..'...
for /f "usebackq tokens=* delims=" %%a in ("%ENV_FILE%") do (
    set "line=%%a"
    if defined line (
        if not "!line:~0,1!"=="#" (
            for /f "tokens=1,* delims==" %%b in ("%%a") do (
                set "%%b=%%c"
            )
        )
    )
)

echo Copy original config files from docker...

echo KIBANA
docker create --name temp docker.elastic.co/kibana/kibana:%STACK_VERSION%
docker cp temp:/usr/share/kibana/config/kibana.yml ./kibana.docker.yml
docker rm temp

echo APM
docker create --name temp docker.elastic.co/apm/apm-server:%STACK_VERSION%
docker cp temp:/usr/share/apm-server/apm-server.yml ./apm-server.docker.yml
docker rm temp

echo Completed!
