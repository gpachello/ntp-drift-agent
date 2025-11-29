FROM debian:trixie-slim

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
	nano \
    ntpsec-ntpdate \
	faketime \
	python3 \
	python3-paho-mqtt && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -r agent && useradd -r -g agent -d /agent -s /bin/sh agent

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER agent
WORKDIR /agent

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
