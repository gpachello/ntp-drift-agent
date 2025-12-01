FROM debian:trixie-slim

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
	nano \
	faketime \
	python3 \
	python3-paho-mqtt \
	python3-ntplib && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -r agent && useradd -r -g agent -d /agent -s /bin/sh agent

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER agent
WORKDIR /agent

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
