@echo off

:: Set the container name as a variable
set CONTAINER_NAME=all-in-one-compose-metricbeat-1

:: Create metricbeat_config folder if it doesn't exist
if not exist metricbeat_config (
    mkdir metricbeat_config
)

:: Copy modules.d from Docker container to metricbeat folder
docker cp %CONTAINER_NAME%:/usr/share/metricbeat/modules.d/. metricbeat_config/