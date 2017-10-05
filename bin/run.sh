#!/bin/sh

TMP_CONFIG=/tmp/kibana.tpl

export KIBANA_INDEX_NAME=".kibana-${KIBANA_HOST}"

# Test if need to cast kibana template
if [[ -f ${TMP_CONFIG} ]]; then
    envtpl < /tmp/kibana.tpl > ${KIBANA_HOME_DIR}/config/kibana.yml
fi

# Wait until cluster up
sleep 2m

# Create kibana index
if [[ $(curl --write-out %{http_code} --silent --output /dev/null "${ELASTIC_HOST}:9213/${KIBANA_INDEX_NAME}") -eq 404 ]]; then
  curl -XPUT "${ELASTIC_HOST}:9213/${KIBANA_INDEX_NAME}" -d'{"settings" :{"index" : {"number_of_shards" : 1, "number_of_replicas" : 3}}}'
fi

# Run kibana
${KIBANA_HOME_DIR}/bin/kibana
