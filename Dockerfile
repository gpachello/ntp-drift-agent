FROM debian:trixie-slim

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
	nano \
    ntpsec-ntpdate \
	faketime \
	python3 \
	python3-paho-mqtt && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -r usuario && useradd -r -g usuario -d /usuario -s /bin/sh usuario

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER usuario
WORKDIR /usuario

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
