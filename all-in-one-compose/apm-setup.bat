@echo off

set ELASTIC_URL=https://localhost:9200
set ELASTIC_USER=elastic
set ELASTIC_PASSWORD=elastic

(
  echo {
  echo   "index_patterns": ["logs-apm.error-*"],
  echo   "template": {
  echo     "settings": {
  echo       "index": {
  echo         "number_of_shards": 1,
  echo         "number_of_replicas": 0
  echo       }
  echo     },
  echo     "mappings": {
  echo       "properties": {
  echo         "@timestamp": {"type": "date"},
  echo         "message": {"type": "text"},
  echo         "service.name": {"type": "keyword"},
  echo         "service.version": {"type": "keyword"},
  echo         "error.exception": {"type": "keyword"},
  echo         "error.stack_trace": {"type": "text"}
  echo       }
  echo     }
  echo   }
  echo }
) > logs_apm_error_template.json

(
  echo {
  echo   "index_patterns": ["traces-apm.sampled-*"],
  echo   "template": {
  echo     "settings": {
  echo       "index": {
  echo         "number_of_shards": 1,
  echo         "number_of_replicas": 0
  echo       }
  echo     },
  echo     "mappings": {
  echo       "properties": {
  echo         "@timestamp": {"type": "date"},
  echo         "trace.id": {"type": "keyword"},
  echo         "trace.span.id": {"type": "keyword"},
  echo         "service.name": {"type": "keyword"},
  echo         "service.version": {"type": "keyword"}
  echo       }
  echo     }
  echo   }
  echo }
) > traces_apm_sampled_template.json

(
  echo {
  echo   "index_patterns": ["traces-apm-*"],
  echo   "template": {
  echo     "settings": {
  echo       "index": {
  echo         "number_of_shards": 1,
  echo         "number_of_replicas": 0
  echo       }
  echo     },
  echo     "mappings": {
  echo       "properties": {
  echo         "@timestamp": {"type": "date"},
  echo         "trace.id": {"type": "keyword"},
  echo         "trace.span.id": {"type": "keyword"},
  echo         "service.name": {"type": "keyword"},
  echo         "service.version": {"type": "keyword"}
  echo       }
  echo     }
  echo   }
  echo }
) > traces_apm_template.json

(
  echo {
  echo   "index_patterns": ["metrics-apm.app-*"],
  echo   "template": {
  echo     "settings": {
  echo       "index": {
  echo         "number_of_shards": 1,
  echo         "number_of_replicas": 0
  echo       }
  echo     },
  echo     "mappings": {
  echo       "properties": {
  echo         "@timestamp": {"type": "date"},
  echo         "metricset.name": {"type": "keyword"},
  echo         "metricset.namespace": {"type": "keyword"},
  echo         "service.name": {"type": "keyword"},
  echo         "service.node.name": {"type": "keyword"}
  echo       }
  echo     }
  echo   }
  echo }
) > metrics-apm.app-template.json

(
  echo {
  echo   "index_patterns": ["metrics-apm.internal-*"],
  echo   "template": {
  echo     "settings": {
  echo       "index": {
  echo         "number_of_shards": 1,
  echo         "number_of_replicas": 0
  echo       }
  echo     },
  echo     "mappings": {
  echo       "properties": {
  echo         "@timestamp": {"type": "date"},
  echo         "metricset.name": {"type": "keyword"},
  echo         "metricset.namespace": {"type": "keyword"},
  echo         "service.name": {"type": "keyword"},
  echo         "service.node.name": {"type": "keyword"}
  echo       }
  echo     }
  echo   }
  echo }
) > metrics-apm.internal-template.json

echo Creating logs-apm.error index template
curl -v -XPUT "%ELASTIC_URL%/_index_template/logs-apm.error?pretty" -H "Content-Type: application/json" -u %ELASTIC_USER%:%ELASTIC_PASSWORD% -d @logs_apm_error_template.json -k
echo ==============================
echo.

echo Creating traces-apm.sampled index template
curl -v -XPUT "%ELASTIC_URL%/_index_template/traces-apm.sampled?pretty" -H "Content-Type: application/json" -u %ELASTIC_USER%:%ELASTIC_PASSWORD% -d @traces_apm_sampled_template.json -k
echo ==============================
echo.

echo Creating traces-apm index template
curl -v -XPUT "%ELASTIC_URL%/_index_template/traces-apm?pretty" -H "Content-Type: application/json" -u %ELASTIC_USER%:%ELASTIC_PASSWORD% -d @traces_apm_template.json -k
echo ==============================
echo.

echo Creating metrics-apm.app index template
curl -v -XPUT "%ELASTIC_URL%/_index_template/metrics-apm.app?pretty" -H "Content-Type: application/json" -u %ELASTIC_USER%:%ELASTIC_PASSWORD% -d @metrics-apm.app-template.json -k
echo ==============================
echo.

echo Creating metrics-apm.internal index template
curl -v -XPUT "%ELASTIC_URL%/_index_template/metrics-apm.internal?pretty" -H "Content-Type: application/json" -u %ELASTIC_USER%:%ELASTIC_PASSWORD% -d @metrics-apm.internal-template.json -k
echo ==============================
echo.

pause
