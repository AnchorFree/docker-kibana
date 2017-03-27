FROM alpine:3.5

ENV KIBANA_VERSION 5.2.2

RUN apk add --update bash curl nodejs py-pip && \
    curl -fL https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz | tar xzf - -C /srv && \
    mv /srv/kibana-${KIBANA_VERSION}-linux-x86_64 /srv/kibana && \
    rm -rf /srv/kibana/node && \
    mkdir -p /srv/kibana/node/bin/ && \
    ln -s $(which node) /srv/kibana/node/bin/node && \
    rm -rf /var/cache/apk/*

RUN pip install envtpl

ADD bin/run.sh /usr/bin/run.sh
ADD config/kibana.tpl /tmp/kibana.tpl

RUN chmod +x /usr/bin/run.sh

CMD ["/usr/bin/run.sh"]
