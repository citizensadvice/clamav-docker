FROM debian:jessie-slim

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y -qq curl clamav clamav-daemon clamav-freshclam wget gettext-base && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV TINI_VERSION v0.14.0

RUN set -x \
    && curl -fSL "https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini-static" -o /usr/local/bin/tini \
    && curl -fSL "https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini-static.asc" -o /usr/local/bin/tini.asc \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 6380DC428747F6C393FEACA59A84159D7001A4E5 \
    && gpg --batch --verify /usr/local/bin/tini.asc /usr/local/bin/tini \
    && rm -r "$GNUPGHOME" /usr/local/bin/tini.asc \
    && chmod +x /usr/local/bin/tini

RUN wget -O /var/lib/clamav/main.cvd http://database.clamav.net/main.cvd && \
    wget -O /var/lib/clamav/daily.cvd http://database.clamav.net/daily.cvd && \
    wget -O /var/lib/clamav/bytecode.cvd http://database.clamav.net/bytecode.cvd && \
    chown clamav:clamav /var/lib/clamav/*.cvd

RUN mkdir /var/run/clamav && \
    chown clamav:clamav /var/run/clamav && \
    chmod 750 /var/run/clamav

EXPOSE 3310

ADD bootstrap.sh /
ADD clamd.conf.template /etc/clamav/
ADD freshclam.conf.template /etc/clamav/

ENV MAX_THREADS 12
ENV MAX_CONNECTION_QUEUE_LENGTH 15
ENV MAX_QUEUE=100
ENV MAX_SCAN_SIZE 100M
ENV MAX_FILE_SIZE 100M

#ENTRYPOINT ["/usr/local/bin/tini", "-g", "--"]

CMD ["/bootstrap.sh"]
