#!/bin/bash

# CONFIGURAR LAS CARPETAS DE MONTAJE DE DISCOS DUROS EXTERNOS-----------------------------------------------------

mkdir /mnt/HDD1TB
mkdir /mnt/HDD2TB
mkdir /mnt/WINDOWS
mkdir /mnt/RESPALDO

cp /etc/fstab /etc/fstab.bak

cat <<EOF >> /etc/fstab
UUID=01D644D76CBD96F0 /mnt/HDD1TB auto nosuid,nodev,nofail,noauto,x-gvfs-show 0 0
UUID=92F2437BF2436319 /mnt/HDD2TB auto nosuid,nodev,nofail,noauto,x-gvfs-show 0 0
/dev/disk/by-uuid/F6B60087B6004A97 /mnt/WINDOWS auto nosuid,nodev,nofail,x-gvfs-show,x-gvfs-name=Windows 0 0
/dev/disk/by-id/usb-ADATA_ED600_000000000076-0:0-part1 /mnt/RESPALDO auto nosuid,nodev,nofail,noauto,x-gvfs-show 0 0
EOF


# INSTALAR PAQUETES-----------------------------------------------------

sudo dnf install -y podman podman-compose podman-docker clementine filelight keepassxc nextcloud-client kid3 krename ktorrent profile-cleaner libwebp libwebp-tools

# INSTALAR CZKAWKA

# Define variables
DOWNLOAD_URL="https://github.com/qarmin/czkawka/releases/download/7.0.0/linux_czkawka_gui"
INSTALL_DIR="$HOME/.local/my-apps/czkawka"
DESKTOP_FILE="$HOME/.local/share/applications/czkawka.desktop"

# Crear el directorio si no existe
mkdir -p "$INSTALL_DIR"

# Descargar el archivo
wget "$DOWNLOAD_URL" -O "$INSTALL_DIR/linux_czkawka_gui"

# Dar permisos de ejecución
chmod +x "$INSTALL_DIR/linux_czkawka_gui"

# Crear el archivo .desktop
cat << EOF > "$DESKTOP_FILE"
[Desktop Entry]
Name=Czkawka
Comment=Duplicate file finder
Exec=$INSTALL_DIR/linux_czkawka_gui
Icon=applications-other
Terminal=false
Type=Application
Categories=Utility;
EOF

# INSTALAR FREEOFFICE
wget https://www.freeoffice.com/download.php?filename=https://www.softmaker.net/down/softmaker-freeoffice-2024-1216.x86_64.rpm -o $HOME/Descargas
sudo dnf install $HOME/Descargas/softmaker-freeoffice-2024-1216.x86_64.rpm

# INSTALAR VS CODIUM
wget https://github.com/VSCodium/vscodium/releases/download/1.92.1.24225/codium-1.92.1.24225-el8.x86_64.rpm -o $HOME/Descargas
sudo dnf install $HOME/Descargas/codium-1.92.1.24225-el8.x86_64.rpm

# INSTALAR HAKUNEKO
wget https://github.com/manga-download/hakuneko/releases/download/v6.1.7/hakuneko-desktop_6.1.7_linux_amd64.rpm -o $HOME/Descargas
sudo dnf install $HOME/Descargas/hakuneko-desktop_6.1.7_linux_amd64.rpm