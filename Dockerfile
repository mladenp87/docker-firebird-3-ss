FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y wget libtommath1 libicu-dev vim nano tzdata procps && \
    ln -sf /usr/lib/x86_64-linux-gnu/libtommath.so.1 /usr/lib/x86_64-linux-gnu/libtommath.so.0 && \
    cd /root && \
    wget https://github.com/FirebirdSQL/firebird/releases/download/R3_0_4/Firebird-3.0.4.33054-0.amd64.tar.gz && \
    tar xzvpf Firebird-3.0.4.33054-0.amd64.tar.gz && cd Firebird-3.0.4.33054-0.amd64/ && ./install.sh -silent && \
    echo "RemoteAuxPort = 5000" >>/opt/firebird/firebird.conf

ENV PATH $PATH:/opt/firebird/bin

ADD run.sh /opt/firebird/run.sh
RUN chmod +x /opt/firebird/run.sh

VOLUME /data
VOLUME /backup

EXPOSE 3050 5000

ENTRYPOINT ["/opt/firebird/run.sh"]
