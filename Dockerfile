FROM alpine:3.7

ENV kibana_version 5.6.4
ENV kibana_home_dir /srv/kibana
ENV kibana_plugin ${kibana_home_dir}/bin/kibana-plugin

RUN apk add --update bash curl nodejs py-pip && \
    curl -fL https://artifacts.elastic.co/downloads/kibana/kibana-${kibana_version}-linux-x86_64.tar.gz | tar xzf - -C /srv && \
    mv /srv/kibana-${kibana_version}-linux-x86_64 ${kibana_home_dir} && \
    rm -rf ${kibana_home_dir}/node && \
    mkdir -p ${kibana_home_dir}/node/bin/ && \
    ln -s $(which node) ${kibana_home_dir}/node/bin/node && \
    rm -rf /var/cache/apk/*

RUN ${kibana_plugin} install x-pack

RUN pip install envtpl

ADD bin/entrypoint.sh /usr/bin/entrypoint.sh
ADD config/kibana.tpl /tmp/kibana.tpl

CMD ["/usr/bin/entrypoint.sh"]
