@echo off

for /f "skip=1 delims={}, " %%A in ('wmic nicconfig get ipaddress') do for /f "tokens=1" %%B in ("%%~A") do set "IP=%%~B"
for /f "tokens=1 delims=:" %%j in ('ping %computername% -4 -n 1 ^| findstr Reply') do (
    set localip=%%j
)

set HOST_IP=%localip:~11%

echo HOST_IP is: %HOST_IP%

(
  echo services:
  echo.
  echo   setup:
  echo     image: alpine:latest
  echo     volumes:
  echo       - ./setup.sh:/setup.sh
  echo     command: sh /setup.sh
  echo     environment:
  echo       - HOST_IP=%HOST_IP%
) > docker-compose.yml

docker-compose up
