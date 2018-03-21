FROM alpine:3.5

ENV KIBANA_VERSION 6.2.3
ENV KIBANA_HOME_DIR /srv/kibana
ENV KIBANA_PLUGIN ${KIBANA_HOME_DIR}/bin/kibana-plugin

RUN apk add --update bash curl nodejs && \
    curl -fL https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz | tar xzf - -C /srv && \
    mv /srv/kibana-${KIBANA_VERSION}-linux-x86_64 ${KIBANA_HOME_DIR} && \
    rm -rf ${KIBANA_HOME_DIR}/node && \
    mkdir -p ${KIBANA_HOME_DIR}/node/bin/ && \
    ln -s $(which node) ${KIBANA_HOME_DIR}/node/bin/node && \
    rm -rf /var/cache/apk/*

ADD bin/run.sh /usr/bin/run.sh
RUN ${KIBANA_PLUGIN} install x-pack \
    && chmod +x /usr/bin/run.sh

CMD ["/usr/bin/run.sh"]
