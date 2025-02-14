#!/bin/bash

java \
    -javaagent:/usr/app/elastic-apm-agent.jar \
    -Dspring.profiles.active=dev \
    -jar /usr/app/app.jar
