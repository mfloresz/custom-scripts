#!/bin/bash

# Ruta al script de actualización de yt-dlp
SCRIPT_PATH="/ruta/al/script/update_yt-dlp.sh"

# Crear el script de actualización de yt-dlp
cat << EOF > $SCRIPT_PATH
#!/bin/bash

# Actualizar yt-dlp
yt-dlp -U
EOF

# Dar permisos de ejecución al script
chmod +x $SCRIPT_PATH

# Abrir el editor de cron
crontab -e

# Agregar la tarea al cron
echo "0 3 * * * $SCRIPT_PATH" >> /tmp/crontab.txt
crontab /tmp/crontab.txt

echo "Tarea de actualización de yt-dlp agregada al cron."
