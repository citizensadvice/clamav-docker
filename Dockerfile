FROM krallin/ubuntu-tini:xenial

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y -qq curl clamav clamav-daemon clamav-freshclam wget gettext-base sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /var/run/clamav && \
    touch /etc/clamav/clamd.conf && \
    touch /etc/clamav/freshclam.conf && \
    chown -R clamav:clamav /var/run/clamav /etc/clamav && \
    chmod 660 /etc/clamav/*.conf && \
    chmod 770 /var/run/clamav

EXPOSE 3310

ADD bootstrap.sh /
ADD clamd.conf.template /etc/clamav/
ADD freshclam.conf.template /etc/clamav/

RUN freshclam --verbose

ENV MAX_THREADS 12
ENV MAX_CONNECTION_QUEUE_LENGTH 15
ENV MAX_QUEUE=100
ENV MAX_SCAN_SIZE 100M
ENV MAX_FILE_SIZE 100M
ENV MAX_STREAM_LENGTH 100M

RUN useradd -u 1000 clamavbootstrap -U -G clamav && \
    echo "clamavbootstrap ALL=(clamav:clamav) NOPASSWD: /usr/local/bin/tini -s -g -- freshclam -d &" >> /etc/sudoers.d/clamavbootstrap && \
    echo "clamavbootstrap ALL=(clamav:clamav) NOPASSWD: /usr/local/bin/tini -s -g -- clamd" >> /etc/sudoers.d/clamavbootstrap

USER 1000

CMD ["/bootstrap.sh"]
