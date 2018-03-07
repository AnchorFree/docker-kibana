#!/bin/sh

TMP_CONFIG=/tmp/kibana.tpl

export KIBANA_INDEX_NAME=".kibana-${KIBANA_HOST}"

# Test if need to cast kibana template
if [[ -f ${TMP_CONFIG} ]]; then
    envtpl < /tmp/kibana.tpl > ${KIBANA_HOME_DIR}/config/kibana.yml
fi

# Create kibana index
if [[ $(curl --write-out %{http_code} --silent --output /dev/null "${ELASTICSEARCH_HOST}:${ELASTICSEARCH_PORT}/${KIBANA_INDEX_NAME}") -eq 404 ]]; then
  curl -XPUT "${ELASTICSEARCH_HOST}:${ELASTICSEARCH_PORT}/${KIBANA_INDEX_NAME}" -d'{"settings" :{"index" : {"number_of_shards" : ${ELASTICSEARCH_SHARDS}, "number_of_replicas" : ${ELASTICSEARCH_REPLICAS}}}}'
fi

curl "http://${ELASTICSEARCH_HOST}:${ELASTICSEARCH_PORT}/"

# Run kibana
${KIBANA_HOME_DIR}/bin/kibana
