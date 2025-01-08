import logging
import subprocess
import sys
import os
import requests
import base64
from PIL import Image

# Configurar logging
logging.basicConfig(
    filename='/tmp/fal_ai_debug.log',
    level=logging.DEBUG,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

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

        # Verificar si el archivo existe y es accesible
        if not os.path.isfile(input_image_path):
            error_msg = f"El archivo {input_image_path} no existe o no es accesible"
            logging.error(error_msg)
            notify(error_msg)
            return

        # Importar fal_client aquí para manejar mejor los errores de importación
        import fal_client

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

        # Generar la ruta de salida
        output_image_path = os.path.splitext(input_image_path)[0] + "-bg-removed.png"
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

        # Verificar argumentos
        if len(sys.argv) != 2:
            error_msg = "Uso: python3 fal_background_removal.py <ruta_de_la_imagen>"
            logging.error(error_msg)
            notify(error_msg)
            sys.exit(1)

        # Verificar dependencias
        check_dependencies()

        # Obtener ruta de la imagen
        input_image_path = sys.argv[1]
        logging.info(f"Ruta de imagen recibida: {input_image_path}")

        # Ejecutar el proceso principal
        remove_background(input_image_path)

        logging.info("Script finalizado exitosamente")

    except Exception as e:
        error_msg = f"Error en la ejecución principal: {str(e)}"
        logging.error(error_msg)
        notify(error_msg)
        sys.exit(1)
