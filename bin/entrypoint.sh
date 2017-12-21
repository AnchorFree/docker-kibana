#!/bin/bash

declare -r TMP_CONFIG=/tmp/kibana.tpl
declare -x KIBANA_INDEX_NAME=".kibana-${KIBANA_HOST}"

# Test if need to cast kibana template
if [[ -f ${TMP_CONFIG} ]]; then
  envtpl < /tmp/kibana.tpl > ${KIBANA_HOME_DIR}/config/kibana.yml
fi

# Wait until cluster up
sleep 5m

# Create kibana index
if [[ $(curl --write-out %{http_code} --silent --output /dev/null "${ELASTICSEARCH_HOST}:${ELASTICSEARCH_PORT}/${KIBANA_INDEX_NAME}") -eq 404 ]]; then
  curl -XPUT "${ELASTICSEARCH_HOST}:${ELASTICSEARCH_PORT}/${KIBANA_INDEX_NAME}" -d'{"settings" :{"index" : {"number_of_shards" : 2, "number_of_replicas" : 3}}}'
fi

# Run kibana
${KIBANA_HOME_DIR}/bin/kibana
