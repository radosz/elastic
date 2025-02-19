## Table of Contents

- [Welcome](#welcome)
- [Project Structure](#project-structure)
- [How to Use](#how-to-use)
  - [Download the Repositories](#download-the-repositories)
  - [Adjust the Configuration](#adjust-the-configuration)
  - [Start the Services](#start-the-services)
- [Connect Local Java Application to ELK](#connect-local-java-application-to-elk)
- [Client Docker-Compose Properties](#client-docker-compose-properties)

---

## Welcome

<img src="Elastic_APM.PNG" alt="Elastic APM">

## Project Structure

```
├───client_monitoring
│   ├───app
│   └───metricbeat_config        
├───elk-server
│   └───json
├───helper
└───monitoring
```

- **elk-server**: Contains the ELK stack used for application monitoring.
- **client_monitoring**: Contains Metricbeat and Filebeat configurations. The **app** subfolder provides Windows/Linux scripts for downloading the *apm-agent*, which is required for monitoring Java applications.
- **monitoring**: Contains an example app that can be monitored by the ELK stack.
- **helper**: Contains helper scripts.

The **.env** file holds all configurations for both the client and server.

## How to Use

### Download the Repositories
   
For the client side, run:
   
```bash
git clone git@github.com:radosz/elastic.git --sparse .env
git clone git@github.com:radosz/elastic.git --sparse client_monitoring
git clone git@github.com:radosz/elastic.git --sparse client_monitoring/app
git clone git@github.com:radosz/elastic.git --sparse client_monitoring/metricbeat_config
```
   
For the server side, run:
   
```bash
git clone git@github.com:radosz/elastic.git --sparse .env
git clone git@github.com:radosz/elastic.git --sparse elk-server
git clone git@github.com:radosz/elastic.git --sparse elk-server/json
```

### Adjust the Configuration
   
Edit the **.env** file. The environment already supports TLSv1.3 with a self-signed certificate, and you can set the username and password. Ensure that the client application can communicate properly with the ELK server by setting the correct addresses for Kibana and Elasticsearch.

### Start the Services
   
Bring up the containers using Docker Compose:
   
```bash
docker-compose up -d
```

## Connect Local Java Application to ELK

1. Navigate to **client_monitoring/app** to download jar with APM agent; execute `download_apm_agent.bat` or `download_apm_agent.sh` based on your OS.
2. Start your app:

```bash
#!/bin/bash

java -javaagent:/usr/app/elastic-apm-agent.jar -jar <path-to-your-app.jar>
```

## Client Docker-Compose Properties

```
services:
    ......
    environment:
      - ELASTIC_APM_SERVICE_NAME=app
      - ELASTIC_APM_SERVER_URL=${ELASTIC_APM_SERVER_URL:-https://192.168.100.144:8200}
      - ELASTIC_APM_APPLICATION_PACKAGES=com.myapp
      - ELASTIC_APM_JS_SERVER_URL=${ELASTIC_APM_JS_SERVER_URL:-https://192.168.100.144:8200}
      - ELASTIC_APM_ENABLE_LOG_CORRELATION=true
      - ELASTIC_APM_ENVIRONMENT=DEV
      - ELASTIC_APM_VERIFY_SERVER_CERT=false
      - APM_AGENT_TYPE=elasticapm 
```

---