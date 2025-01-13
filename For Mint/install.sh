#!/bin/bash

# Definir variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
BIN_DIR="$HOME/.local/bin"
NEMO_ACTIONS_DIR="$HOME/.local/share/nemo/actions"
NEMO_SCRIPTS_DIR="$NEMO_ACTIONS_DIR/scripts"

# Crear directorios necesarios
mkdir -p "$BIN_DIR" "$NEMO_ACTIONS_DIR" "$NEMO_SCRIPTS_DIR"

# Copiar scripts de yt-dlp
if [ -d "$SCRIPT_DIR/For yt-dlp" ]; then
    cp "$SCRIPT_DIR/For yt-dlp/"*.sh "$BIN_DIR/"
    cp "$SCRIPT_DIR/For yt-dlp/"*.py "$BIN_DIR/"
    chmod u+x "$BIN_DIR/"*.py
    chmod u+x "$BIN_DIR/"*.sh
    chown "$USER:$USER" "$BIN_DIR/"*.sh
    chown "$USER:$USER" "$BIN_DIR/"*.py
else
    echo "Error: No se encuentra el directorio For yt-dlp"
fi

# Copiar scripts de Comics
if [ -d "$SCRIPT_DIR/For Comics" ]; then
    # Copiar scripts Python y Shell
    cp "$SCRIPT_DIR/For Comics/"*.{py,sh} "$BIN_DIR/" 2>/dev/null || true
    # Copiar fuente TTF si existe
    cp "$SCRIPT_DIR/For Comics/"*.ttf "$BIN_DIR/" 2>/dev/null || true

    # Establecer permisos
    chmod u+x "$BIN_DIR/"*.py "$BIN_DIR/"*.sh 2>/dev/null || true
    chown "$USER:$USER" "$BIN_DIR/"*.{py,sh,ttf} 2>/dev/null || true
else
    echo "Error: No se encuentra el directorio For Comics"
fi

# Copiar scripts de Others
if [ -d "$SCRIPT_DIR/Others" ]; then
    cp "$SCRIPT_DIR/Others/"*.sh "$BIN_DIR/"
    chmod u+x "$BIN_DIR/"*.sh
    chown "$USER:$USER" "$BIN_DIR/"*.sh
else
    echo "Error: No se encuentra el directorio Others"
fi

# Copiar Nemo Actions
if [ -d "$SCRIPT_DIR/Nemo Actions" ]; then
    cp "$SCRIPT_DIR/Nemo Actions/"*.nemo_action "$NEMO_ACTIONS_DIR/"
    chmod u+x "$NEMO_ACTIONS_DIR/"*.nemo_action
    chown "$USER:$USER" "$NEMO_ACTIONS_DIR/"*.nemo_action
else
    echo "Error: No se encuentra el directorio Nemo Actions"
fi

# Copiar scripts de Nemo Actions
if [ -d "$SCRIPT_DIR/Nemo Actions/scripts" ]; then
    cp "$SCRIPT_DIR/Nemo Actions/scripts/"*.sh "$NEMO_SCRIPTS_DIR/" 2>/dev/null || true
    cp "$SCRIPT_DIR/Nemo Actions/scripts/"*.py "$NEMO_SCRIPTS_DIR/" 2>/dev/null || true
    chmod u+x "$NEMO_SCRIPTS_DIR/"*
    chown "$USER:$USER" "$NEMO_SCRIPTS_DIR/"*
else
    echo "Error: No se encuentra el directorio de scripts"
fi

# Verificar la instalación
if [ $? -eq 0 ]; then
    zenity --notification --text "Instalación completada exitosamente"
else
    zenity --error --text "Hubo un error durante la instalación"
fi
