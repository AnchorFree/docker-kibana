#!/bin/bash

declare -r tmp_config=/tmp/kibana.tpl
declare -x kibana_index_name=".kibana-${kibana_host}"

# Test if need to cast kibana template
if [[ -f ${tmp_config} ]]; then
  envtpl < /tmp/kibana.tpl > ${kibana_home_dir}/config/kibana.yml
fi

# Wait until cluster up
sleep 5m

# Create kibana index
if [[ $(curl --write-out %{http_code} --silent --output /dev/null "${elasticsearch_host}:${elasticsearch_port}/${kibana_index_name}") -eq 404 ]]; then
  curl -XPUT "${elasticsearch_host}:${elasticsearch_port}/${kibana_index_name}" -d'{"settings" :{"index" : {"number_of_shards" : 2, "number_of_replicas" : 3}}}'
fi

# Run kibana
${kibana_home_dir}/bin/kibana
