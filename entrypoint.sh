#!/bin/sh
set -e

cat << 'EOF' > /agent/time_drift.py
import subprocess
import json
import re
from datetime import datetime
import paho.mqtt.client as mqtt

THRESHOLD = 300  # segundos
NTP_SRV = "2.ar.pool.ntp.org"
MQTT_HOST = "mqtt"
MQTT_PORT = 1883
MQTT_TOPIC = "LAB/time_drift/agent1"
payload = None

client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, "faketime-check-1")
client.connect(MQTT_HOST, MQTT_PORT, 60)

# Consultar Servidor NTP:
proc = subprocess.run(
    ["ntpdate", "-q", NTP_SRV],
    capture_output=True,
    text=True
)

output = proc.stdout

# Extraer valor:
m = re.search(r"[+-]\d+\.\d+", output)

if not m:
    exit(1)

offset = float(m.group(0))
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

# Desconectar:
client.disconnect()
EOF

#
#
#

# LAST. Mantener contenedor vivo
exec /bin/sh -c "tail -f /dev/null"
