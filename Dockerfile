FROM alpine:3.4

ENV KIBANA_VERSION 4.6.1

RUN apk add --update bash curl nodejs && \
    curl -fL https://download.elastic.co/kibana/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz | tar xzf - -C /srv && \
    mv /srv/kibana-${KIBANA_VERSION}-linux-x86_64 /srv/kibana && \
    rm -rf /srv/kibana/node && \
    mkdir -p /srv/kibana/node/bin/ && \
    ln -s $(which node) /srv/kibana/node/bin/node && \
    sed -i "s/^# elasticsearch\.url: .*/elasticsearch\.url: \"http:\/\/elasticsearch:9200\"/"  /srv/kibana/config/kibana.yml && \
    apk del curl && \
    rm -rf /var/cache/apk/*

CMD ["/srv/kibana/bin/kibana"]
