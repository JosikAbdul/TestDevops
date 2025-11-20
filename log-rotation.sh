#!/usr/bin/env bash
# log-rotation.sh - Rotación por tamaño y antigüedad
LOG_DIR=${1:-/var/log/myapp}
MAX_SIZE_BYTES=$((100*1024*1024)) # 100MB
OLDER_DAYS=7
REMOVE_DAYS=30
LOG_FILE="/var/log/log-rotation.log"

timestamp(){ date '+%Y-%m-%d %H:%M:%S'; }

echo "$(timestamp) - Inicio rotación en $LOG_DIR" >> "$LOG_FILE"

find "$LOG_DIR" -type f -name '*.log' -print0 | while IFS= read -r -d '' file; do
  size=$(stat -c%s "$file")
  moddays=$(expr $(date +%s) - $(stat -c%Y "$file"))
  moddays=$(( moddays / 86400 ))
  if [ "$size" -ge "$MAX_SIZE_BYTES" ] || [ "$moddays" -ge "$OLDER_DAYS" ]; then
    gzip -c "$file" > "${file}.gz"
    if [ $? -eq 0 ]; then
      echo "$(timestamp) - Comprimido: $file -> ${file}.gz" >> "$LOG_FILE"
      : > "$file"
    else
      echo "$(timestamp) - ERROR comprimiendo $file" >> "$LOG_FILE"
    fi
  fi
done

# Eliminar archivos .gz mayores a REMOVE_DAYS
find "$LOG_DIR" -type f -name '*.gz' -mtime +$REMOVE_DAYS -print -delete | while read -r f; do
  echo "$(timestamp) - Eliminado antiguo: $f" >> "$LOG_FILE"
done

echo "$(timestamp) - Fin rotación" >> "$LOG_FILE"
