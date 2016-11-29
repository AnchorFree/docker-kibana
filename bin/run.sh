#!/bin/sh

TMP_CONFIG=/tmp/kibana.tpl

export KIBANA_INDEX_NAME=".kibana-${KIBANA_HOST}"

# Test if need to cast kibana template
if [[ -f ${TMP_CONFIG} ]]; then
    envtpl < /tmp/kibana.tpl > /srv/kibana/config/kibana.yml
fi

if [[ $(curl --write-out %{http_code} --silent --output /dev/null "${ELASTIC_HOST}:9200/${KIBANA_INDEX_NAME}") -eq 404 ]]; then
  curl -XPUT "${ELASTIC_HOST}:9200/${KIBANA_INDEX_NAME}" -d'{"settings" :{"index" : {"number_of_shards" : 1, "number_of_replicas" : 3}}}'
fi

# Run kibana
/srv/kibana/bin/kibana
