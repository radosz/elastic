@echo off
echo Downloading APM agent...

docker create --name temp-apm-container docker.elastic.co/observability/apm-agent-java:1.52.1
docker cp temp-apm-container:/usr/agent/elastic-apm-agent.jar ./elastic-apm-agent.jar
docker rm temp-apm-container

echo Download completed!
