#!/bin/sh
set -e

cat << 'EOF' > /agent/time_drift.py
import json
from datetime import datetime
import ntplib
import paho.mqtt.client as mqtt

THRESHOLD = 300  # segundos
NTP_SRV = "2.ar.pool.ntp.org"
MQTT_HOST = "mqtt"
MQTT_PORT = 1883
MQTT_TOPIC = "LAB/time_drift/agent1"
payload = None

client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, "faketime-check-1")
client.connect(MQTT_HOST, MQTT_PORT, 60)

# Consultar Servidor NTP usando ntplib
try:
    ntp_client = ntplib.NTPClient()
    response = ntp_client.request(NTP_SRV, version=4, timeout=5)
    offset = response.offset      # diferencia (segundos)
except Exception as e:
    # Error consultando NTP → abandonar
    print("Error consultando NTP:", e)
    exit(1)

abs_offset = abs(offset)

# Comparar datos y generar mensaje
if abs_offset > THRESHOLD:
    payload = {
        "event": "time_drift",
        "offset": offset,
        "abs_offset": abs_offset,
        "threshold": THRESHOLD,
        "timestamp": datetime.now().isoformat()
    }

    # Publicar en Broker MQTT
    client.publish(MQTT_TOPIC, json.dumps(payload), qos=1)

    # Desconectar
    client.disconnect()
EOF

#
#
#

# LAST. Mantener contenedor vivo
exec /bin/sh -c "tail -f /dev/null"
