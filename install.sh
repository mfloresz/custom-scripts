#!/bin/bash

# Definir variables
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
BIN_DIR="$HOME/.local/bin"
SERVICEMENU_DIR="$HOME/.local/share/kio/servicemenus"
SERVICEMENU_SCRIPTS_DIR="$SERVICEMENU_DIR/scripts"
COMICS_DIR="$BIN_DIR"

# Instalar paquetes y dependencias
#wget -P "$BIN_DIR" https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
#chmod +x "$BIN_DIR/yt-dlp"
#python3 -m pip install -U gallery-dl

# Crear directorios
mkdir -p "$SERVICEMENU_DIR" "$SERVICEMENU_SCRIPTS_DIR" "$COMICS_DIR"

# Copiar archivos para el menú de servicio de KDE
cp "$SCRIPT_DIR/For KDE/ServiceMenu/tools.desktop" "$SERVICEMENU_DIR/"
cp "$SCRIPT_DIR/For KDE/ServiceMenu/scripts/"*.sh "$SERVICEMENU_SCRIPTS_DIR/"
chown -R "$USER:$USER" "$SERVICEMENU_DIR" "$SERVICEMENU_SCRIPTS_DIR"
chmod -R +x "$SERVICEMENU_DIR" "$SERVICEMENU_SCRIPTS_DIR"

# Copiar archivos para cómics
cp "$SCRIPT_DIR/For Comics/files/OldLondon.ttf" "$COMICS_DIR/"
cp "$SCRIPT_DIR/For Comics/"*.sh "$COMICS_DIR/"
chown -R "$USER:$USER" "$COMICS_DIR"
chmod -R +x "$COMICS_DIR"

# Copiar archivos para yt-dlp
cp "$SCRIPT_DIR/For yt-dlp/"*.sh "$BIN_DIR/"
chown -R "$USER:$USER" "$BIN_DIR"
chmod -R +x "$BIN_DIR"

# Copiar otros scripts
cp "$SCRIPT_DIR/Others/"*.sh "$BIN_DIR/"
chown -R "$USER:$USER" "$BIN_DIR"
chmod -R +x "$BIN_DIR"

# Mostrar mensaje de instalación completa
kdialog --title "Instalación completa" --passivepopup "Los archivos han sido copiados correctamente" 10
