FROM alpine:3.8

ENV KIBANA_VERSION 6.3.2
ENV KIBANA_HOME_DIR /srv/kibana
ENV KIBANA_PLUGIN ${KIBANA_HOME_DIR}/bin/kibana-plugin

RUN apk add --update bash curl nodejs npm && \
    curl -fL https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz | tar xzf - -C /srv && \
    mv /srv/kibana-${KIBANA_VERSION}-linux-x86_64 ${KIBANA_HOME_DIR} && \
    rm -rf ${KIBANA_HOME_DIR}/node && \
    mkdir -p ${KIBANA_HOME_DIR}/node/bin/ && \
    ln -s $(which node) ${KIBANA_HOME_DIR}/node/bin/node && \
    rm -rf /var/cache/apk/*

ADD bin/run.sh /usr/bin/run.sh

RUN apk add --no-cache make gcc g++ python linux-headers binutils-gold gnupg libstdc++ && \
    mkdir -p /tests && \
    curl -fL https://nodejs.org/dist/v10.3.0/node-v10.3.0.tar.gz | tar xzf - -C /tests && \
    cd /tests/node-v10.3.0 && \
    ./configure && \
    make -j$(getconf _NPROCESSORS_ONLN) && \
    mv /tests/node-v10.3.0/out/Release/node /usr/bin/node10 && \
    rm -rf /tests/node-v10.3.0 && \
    apk del make gcc g++ python linux-headers binutils-gold gnupg

RUN echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk add --no-cache \
      chromium@edge \
      nss@edge

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
RUN cd /tests && \
    npm install puppeteer

ADD tests/* /tests

CMD ["/usr/bin/run.sh"]
