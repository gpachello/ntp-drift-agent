#!/bin/sh
set -e

cat << 'EOF' > /usuario/time_drift.sh
#!/bin/bash
THRESHOLD=300  # segundos
NTP_SERVER="2.ar.pool.ntp.org"
LOGFILE="/usuario/time_drift.log"

current_ts=$(date +%s)
ntp_ts=$(ntpdate -q "$NTP_SERVER" 2>/dev/null | grep -o '[+-][0-9]\{1,\}\.[0-9]\{1,\}' | head -1)

if [[ -z "$ntp_ts" ]]; then
    echo "$(date) - ERROR: no se pudo consultar NTP" >> "$LOGFILE"
    exit 1
fi

# valor absoluto sin bc
offset=$(echo "$ntp_ts" | awk '{print ($1 < 0 ? -$1 : $1)}')

# comparación de flotantes con awk
if awk "BEGIN {exit !($offset > $THRESHOLD)}"; then
    echo "$(date) - ALERTA: desvío de tiempo detectado (${offset}s)" >> "$LOGFILE"
fi
EOF

chmod +x /usuario/time_drift.sh

cat << 'EOF' > /usuario/pub-mqtt.py
import paho.mqtt.client as mqtt

client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, 'id0001')

client.connect("mqtt", 1883, 60)

client.publish("TEST", "Mensaje de prueba")
client.disconnect()
EOF

#
#
#

# LAST. Mantener contenedor vivo
exec /bin/sh -c "tail -f /dev/null"
