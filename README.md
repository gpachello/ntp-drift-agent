# NTP Drift Agent
**NTP Drift Agent** es un contenedor liviano diseñado para detectar desviaciones (drift) en la fecha y hora del sistema y reportarlas mediante **MQTT**, permitiendo monitoreo externo, auditoría, pruebas de laboratorio y verificación de integridad temporal.

Su principal objetivo es actuar como un agente autónomo, ideal para entornos de desarrollo, testing, automatización o simulación, especialmente cuando se utiliza manipulación temporal (e.g. con faketime).

---

## 🚀 Características

* Detecta cambios o desviaciones en:
  * Fecha/hora del sistema
  * Deriva temporal (drift)
  * Offsets inesperados
* Publicación de eventos vía MQTT (MQTT-Broker: ```eclipse-mosquitto:openssl```)
* Imagen Docker minimalista basada en Debian Trixie-slim
* Sin dependencias externas complejas
* Configuración simple mediante variables de entorno
* Útil para LABs, pipelines de CI, simulación de fallas y observabilidad temporal

---

## 🐳 Uso

**1. Clonar el repositorio:**
```bash
git clone https://github.com/gpachello/ntp-drift-agent.git
cd ntp-drift-agent
```

**2. Construir y levantar el servicio**

```bash
docker compose up -d --build
```

**3. Verificá el estado:**
```bash
docker compose ps
```

**4. Deberías ver los servicios ejecutándose:**
```bash
NAME              IMAGE                             COMMAND                  SERVICE           CREATED          STATUS          PORTS
mqtt              eclipse-mosquitto:openssl         "/docker-entrypoint.…"   mqtt              17 seconds ago   Up 12 seconds   0.0.0.0:1883->1883/tcp
ntp-drift-agent   ntp-drift-agent-ntp-drift-agent   "/usr/local/bin/entr…"   ntp-drift-agent   15 seconds ago   Up 10 seconds   
```

**5. Ingresar al contenedor:**
```bash
docker compose exec -it ntp-drift-agent bash
```

---

## 📂 Espacio de trabajo

El directorio `/agent/` es el workspace principal.

> [!NOTE]
> Se puede ejecutar un TEST con el siguiente comando:
> ```bash
> faketime HH:MM python3 time_drift.py
> ```
> Reemplazar HH:MM con un valor que exceda los 300 segundos (5 minutos) para que se detecte la desviación de tiempo y se envíe el mensaje al MQTT Broker.

---

## Breve descripción de funcionamiento del script `time_drift.py`

1. El script consulta un servidor NTP usando **ntplib** y calcula la diferencia entre la hora local del sistema y la hora proporcionada por el servidor.
2. Si el desfasaje supera un umbral configurable, envía un mensaje **JSON** a un broker **MQTT** para notificar el evento.

Es un ejemplo simple y extensible de cómo detectar *time drift* y publicar alertas en sistemas distribuidos.

---

## 📨 Publicación MQTT

Por defecto, el agente envía mensajes cuando detecta una variación.
Ejemplo de payload:

```bash
{
  "event": "time_drift",
  "offset": 394.000908,
  "abs_offset": 394.000908,
  "threshold": 300,
  "timestamp": "2025-11-29T17:05:01.442511"
}

```

## ⚙️ Variables de entorno

| Variable         | Descripción                       | Valor por defecto       |
| ---------------- | --------------------------------- | ----------------------- |
| `THRESHOLD`      | Limite / umbral en segundos       | `300`                   |
| `NTP_SRV`        | Servidor NTP externo              | `2.ar.pool.ntp.org`     |
| `MQTT_HOST`      | Hostname del broker MQTT          | `localhost`             |
| `MQTT_PORT`      | Puerto del broker                 | `1883`                  |
| `MQTT_TOPIC`     | Filtro de mensajes MQTT           | `LAB/time_drift/agent1` |

---

## 🔍 Casos de uso

* LABs de simulación con `faketime`
* Validación de licenciamiento local
* Monitoreo de deriva temporal en dispositivos embarcados
* Auditoría de integridad temporal
* Detección de manipulación del reloj del sistema
* Instrumentación en entornos de CI/CD

