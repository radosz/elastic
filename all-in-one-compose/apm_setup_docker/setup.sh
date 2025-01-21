#!/bin/sh

ELASTIC_URL="https://${HOST_IP}:9200"
ELASTIC_USER="elastic"
ELASTIC_PASSWORD="elastic"

cat > traces_apm_sampled_template.json <<EOF
{
  "index_patterns": ["traces-apm.sampled-*"],
  "template": {
    "settings": {
      "index": {
        "number_of_shards": 1,
        "number_of_replicas": 0
      }
    },
    "mappings": {
      "properties": {
        "@timestamp": {"type": "date"},
        "trace.id": {"type": "keyword"},
        "trace.span.id": {"type": "keyword"},
        "service.name": {"type": "keyword"},
        "service.version": {"type": "keyword"}
      }
    }
  }
}
EOF

cat > traces_apm_template.json <<EOF
{
  "index_patterns": ["traces-apm-*"],
  "template": {
    "settings": {
      "index": {
        "number_of_shards": 1,
        "number_of_replicas": 0
      }
    },
    "mappings": {
      "properties": {
        "@timestamp": {"type": "date"},
        "trace.id": {"type": "keyword"},
        "trace.span.id": {"type": "keyword"},
        "service.name": {"type": "keyword"},
        "service.version": {"type": "keyword"}
      }
    }
  }
}
EOF

cat > metrics-apm.app-template.json <<EOF
{
  "index_patterns": ["metrics-apm.app-*"],
  "template": {
    "settings": {
      "index": {
        "number_of_shards": 1,
        "number_of_replicas": 0
      }
    },
    "mappings": {
      "properties": {
        "@timestamp": {"type": "date"},
        "metricset.name": {"type": "keyword"},
        "metricset.namespace": {"type": "keyword"},
        "service.name": {"type": "keyword"},
        "service.node.name": {"type": "keyword"}
      }
    }
  }
}
EOF

cat > metrics-apm.internal-template.json <<EOF
{
  "index_patterns": ["metrics-apm.internal-*"],
  "template": {
    "settings": {
      "index": {
        "number_of_shards": 1,
        "number_of_replicas": 0
      }
    },
    "mappings": {
      "properties": {
        "@timestamp": {"type": "date"},
        "metricset.name": {"type": "keyword"},
        "metricset.namespace": {"type": "keyword"},
        "service.name": {"type": "keyword"},
        "service.node.name": {"type": "keyword"}
      }
    }
  }
}
EOF

cat > logs_apm_error_template.json <<EOF
{
  "index_patterns": ["logs-apm.error-*"],
  "template": {
    "settings": {
      "index": {
        "number_of_shards": 1,
        "number_of_replicas": 0
      }
    },
    "mappings": {
      "properties": {
        "@timestamp": {"type": "date"},
        "message": {"type": "text"},
        "service.name": {"type": "keyword"},
        "service.version": {"type": "keyword"},
        "error.exception": {"type": "keyword"},
        "error.stack_trace": {"type": "text"}
      }
    }
  }
}
EOF

apk add --no-cache curl

echo "Creating traces-apm.sampled index template"
curl -v -XPUT "${ELASTIC_URL}/_index_template/traces-apm.sampled?pretty" -H "Content-Type: application/json" -u ${ELASTIC_USER}:${ELASTIC_PASSWORD} -d @traces_apm_sampled_template.json -k
echo "=============================="

echo "Creating traces-apm index template"
curl -v -XPUT "${ELASTIC_URL}/_index_template/traces-apm?pretty" -H "Content-Type: application/json" -u ${ELASTIC_USER}:${ELASTIC_PASSWORD} -d @traces_apm_template.json -k
echo "=============================="

echo "Creating metrics-apm.app index template"
curl -v -XPUT "${ELASTIC_URL}/_index_template/metrics-apm.app?pretty" -H "Content-Type: application/json" -u ${ELASTIC_USER}:${ELASTIC_PASSWORD} -d @metrics-apm.app-template.json -k
echo "=============================="

echo "Creating metrics-apm.internal index template"
curl -v -XPUT "${ELASTIC_URL}/_index_template/metrics-apm.internal?pretty" -H "Content-Type: application/json" -u ${ELASTIC_USER}:${ELASTIC_PASSWORD} -d @metrics-apm.internal-template.json -k
echo "=============================="

echo "Creating logs-apm.error index template"
curl -v -XPUT "${ELASTIC_URL}/_index_template/logs-apm.error?pretty" -H "Content-Type: application/json" -u ${ELASTIC_USER}:${ELASTIC_PASSWORD} -d @logs_apm_error_template.json -k
echo "=============================="
