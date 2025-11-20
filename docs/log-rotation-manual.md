# Manual - Script de Rotación de Logs

Instalación:
1. Copiar `log-rotation.sh` a `/usr/local/bin/` y dar permisos:
   sudo cp log-rotation.sh /usr/local/bin/
   sudo chmod +x /usr/local/bin/log-rotation.sh

2. Crear cron job (ejemplo en /etc/cron.d/log-rotation):
   30 1 * * * root /usr/local/bin/log-rotation.sh /var/log/myapp

Parámetros:
- El script acepta un parámetro opcional: ruta del directorio de logs.
- Valores configurables al inicio del script:
  MAX_SIZE_BYTES (100MB), OLDER_DAYS (7), REMOVE_DAYS (30)

Registro:
- Todas las acciones quedan registradas en /var/log/log-rotation.log

Consideraciones:
- Probar en entorno staging antes de producción.
- Ajustar permisos y usuarios para acceder a logs.
