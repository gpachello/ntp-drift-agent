# NTP Drift Agent
NTP Drift Agent es un contenedor liviano diseñado para detectar desviaciones (drift) en la fecha y hora del sistema y reportarlas mediante MQTT, permitiendo monitoreo externo, auditoría, pruebas de laboratorio y verificación de integridad temporal.

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

El contenedor se inicia, ajusta permisos de directorios y queda ejecutándose.

**3. Verificá el estado:**
   ```bash
docker compose ps
   ```

**4. Deberías ver los servicios ejecutándose:**
   ```bash
NAME                  IMAGE                           COMMAND                  SERVICE       CREATED          STATUS          PORTS
open-license-server   open-license-server:0.11.2025   "/usr/local/bin/entr…"   opn-lic-srv   16 seconds ago   Up 10 seconds   ```
  ```

**5. Ingresar al contenedor:**
   ```bash
$ docker compose exec -it ntp-drift-agent bash
root@b488c2a55d3c:/lic# 
   ```
