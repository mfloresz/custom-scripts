#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import logging
import subprocess
import sys
import os
import requests
import base64
from PIL import Image
from pathlib import Path
from dotenv import load_dotenv

# Encontrar dinámicamente la ruta del site-packages
python_version = f"python{sys.version_info.major}.{sys.version_info.minor}"
pipx_path = str(Path.home() / ".local/share/pipx/venvs/fal-client/lib" / python_version / "site-packages")
sys.path.append(pipx_path)

# Configurar logging
logging.basicConfig(
    filename='/tmp/fal_ai_debug.log',
    level=logging.DEBUG,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

# Verificar argumentos
assert len(sys.argv) == 2

# Obtener la ruta completa del archivo
input_complete_filename = sys.argv[1]
path = os.path.dirname(input_complete_filename)
input_filename_without_ext = os.path.splitext(os.path.basename(input_complete_filename))[0]

# Verificar que el archivo existe
assert os.path.isfile(input_complete_filename)

def get_api_key():
    # Cargar variables de entorno desde .env
    load_dotenv()
    api_key = os.getenv('FAL_KEY')
    if not api_key:
        error_msg = "API key no encontrada. Por favor, configure la variable FAL_KEY en el archivo .env"
        logging.error(error_msg)
        notify(error_msg)
        sys.exit(1)
    return api_key

def notify(message):
    try:
        subprocess.run(['notify-send', 'Fal.ai Background Removal', message])
        logging.info(f"Notificación enviada: {message}")
    except Exception as e:
        logging.error(f"Error al enviar notificación: {str(e)}")

def check_dependencies():
    try:
        import fal_client
        from PIL import Image
        import requests
        from dotenv import load_dotenv
        logging.info("Todas las dependencias están instaladas correctamente")
    except ImportError as e:
        error_msg = f"Error de dependencia: {str(e)}"
        logging.error(error_msg)
        notify(error_msg)
        sys.exit(1)

def on_queue_update(update):
    try:
        if isinstance(update, fal_client.InProgress):
            for log in update.logs:
                message = log["message"]
                logging.info(f"Progreso: {message}")
                notify(message)
    except Exception as e:
        logging.error(f"Error en on_queue_update: {str(e)}")

def remove_background(input_image_path):
    try:
        logging.info(f"Iniciando proceso con imagen: {input_image_path}")
        notify("Iniciando proceso de eliminación de fondo...")

        # Importar fal_client aquí para manejar mejor los errores de importación
        import fal_client

        # Configurar API key
        fal_client.api_key = get_api_key()

        # Cargar la imagen y convertirla a base64
        logging.info("Cargando imagen y codificando en base64")
        with open(input_image_path, "rb") as image_file:
            try:
                # Leer el archivo y codificarlo en base64
                bytes_content = image_file.read()
                base64_content = base64.b64encode(bytes_content).decode('utf-8')
                encoded_string = f"data:image/png;base64,{base64_content}"
                logging.info("Imagen codificada exitosamente")
            except Exception as e:
                error_msg = f"Error al codificar la imagen: {str(e)}"
                logging.error(error_msg)
                notify(error_msg)
                return

        # Enviar solicitud a la API
        logging.info("Enviando solicitud a la API de Fal.ai")
        try:
            result = fal_client.subscribe(
                "fal-ai/birefnet/v2",
                arguments={
                    "image_url": encoded_string,
                    "model": "General Use (Light)",
                    "operating_resolution": "1024x1024",
                    "output_format": "png",
                    "refine_foreground": True
                },
                with_logs=True,
                on_queue_update=on_queue_update,
            )
            logging.info("Solicitud a la API completada exitosamente")
        except Exception as e:
            error_msg = f"Error en la API de Fal.ai: {str(e)}"
            logging.error(error_msg)
            notify(error_msg)
            return

        # Obtener la URL de la imagen procesada
        image_url = result["image"]["url"]
        logging.info(f"URL de imagen procesada recibida: {image_url}")

        # Generar la ruta de salida usando las variables globales
        output_image_path = os.path.join(path, input_filename_without_ext + '-bg-removed.png')
        logging.info(f"Ruta de salida: {output_image_path}")

        # Descargar y guardar la imagen procesada
        try:
            response = requests.get(image_url)
            response.raise_for_status()  # Verificar si hay errores HTTP

            with open(output_image_path, 'wb') as f:
                f.write(response.content)

            logging.info("Imagen procesada guardada exitosamente")
            notify("¡Imagen procesada y guardada correctamente!")
        except Exception as e:
            error_msg = f"Error al guardar la imagen procesada: {str(e)}"
            logging.error(error_msg)
            notify(error_msg)
            return

    except Exception as e:
        error_msg = f"Error general en remove_background: {str(e)}"
        logging.error(error_msg)
        notify(error_msg)
        raise

if __name__ == "__main__":
    try:
        logging.info("Iniciando script")

        # Verificar dependencias
        check_dependencies()

        # Ejecutar el proceso principal
        remove_background(input_complete_filename)

        logging.info("Script finalizado exitosamente")

    except Exception as e:
        error_msg = f"Error en la ejecución principal: {str(e)}"
        logging.error(error_msg)
        notify(error_msg)
        sys.exit(1)
