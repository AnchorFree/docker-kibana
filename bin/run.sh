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
if [[ $(curl --write-out %{http_code} --silent --output /dev/null "127.0.0.1:9200/${KIBANA_INDEX_NAME}") -eq 404 ]]; then
  curl -XPUT "127.0.0.1:9200/${KIBANA_INDEX_NAME}" -d'{"settings" :{"index" : {"number_of_shards" : 2, "number_of_replicas" : 3}}}'
fi

# Run kibana
${KIBANA_HOME_DIR}/bin/kibana
