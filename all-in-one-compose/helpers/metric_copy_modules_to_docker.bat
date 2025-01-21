@echo off

:: Set the container name as a variable
set CONTAINER_NAME=all-in-one-compose-metricbeat-1

:: Create metricbeat_config folder if it doesn't exist
if not exist metricbeat_config (
    mkdir metricbeat_config
)

:: Copy metricbeat_config from Local to docker container modules.d
docker cp metricbeat_config/. %CONTAINER_NAME%:/usr/share/metricbeat/modules.d/
