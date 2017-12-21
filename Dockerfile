FROM alpine:3.7

ENV KIBANA_VERSION 5.6.4
ENV KIBANA_HOME_DIR /srv/kibana
ENV KIBANA_PLUGIN ${KIBANA_HOME_DIR}/bin/kibana-plugin

RUN apk add --update bash curl nodejs py-pip && \
    curl -fL https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz | tar xzf - -C /srv && \
    mv /srv/kibana-${KIBANA_VERSION}-linux-x86_64 ${KIBANA_HOME_DIR} && \
    rm -rf ${KIBANA_HOME_DIR}/node && \
    mkdir -p ${KIBANA_HOME_DIR}/node/bin/ && \
    ln -s $(which node) ${KIBANA_HOME_DIR}/node/bin/node && \
    rm -rf /var/cache/apk/*

RUN ${KIBANA_PLUGIN} install x-pack

RUN pip install envtpl

ADD bin/entrypoint.sh /usr/bin/entrypoint.sh
ADD config/kibana.tpl /tmp/kibana.tpl

CMD ["/usr/bin/entrypoint.sh"]
