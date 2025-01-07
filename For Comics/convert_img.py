import os
import pyvips
import shutil

def convert_images_to_webp(work_dir, log_callback=None):
    """
    Convierte todas las imágenes en el directorio de trabajo y sus subdirectorios a formato WebP.

    Args:
        work_dir (str): Directorio de trabajo
        log_callback (callable): Función para enviar mensajes de log a la GUI
    """
    def log(message):
        if log_callback:
            log_callback(message)
        else:
            print(message)

    # Cambiar al directorio de trabajo
    os.chdir(work_dir)
    parent_folder = os.getcwd()

    # Calcular tamaño inicial
    initial_size = sum(
        os.path.getsize(os.path.join(dirpath, filename))
        for dirpath, _, filenames in os.walk(parent_folder)
        for filename in filenames
    )

    log("Starting image conversion...")
    log("")
    log("Converting images...")

    # Procesar cada subdirectorio
    for item in os.listdir(parent_folder):
        if os.path.isdir(item):
            folder_path = os.path.join(parent_folder, item)
            folder_name = os.path.basename(folder_path)
            log(f"Converting images from {folder_name}")

            # Procesar cada imagen en el subdirectorio
            for filename in os.listdir(folder_path):
                file_path = os.path.join(folder_path, filename)
                if filename.lower().endswith(('.jpg', '.jpeg', '.png')):
                    try:
                        # Obtener el nombre base sin extensión
                        name_without_ext = os.path.splitext(filename)[0]
                        webp_path = os.path.join(folder_path, f"{name_without_ext}.webp")

                        # Cargar y convertir la imagen
                        image = pyvips.Image.new_from_file(file_path)
                        image.webpsave(webp_path, Q=70)

                        # Eliminar el archivo original solo si la conversión fue exitosa
                        os.remove(file_path)
                    except Exception as e:
                        log(f"Error converting {filename}: {str(e)}")
                        # Si hubo error y se creó el archivo webp, eliminarlo
                        if os.path.exists(webp_path):
                            os.remove(webp_path)

    # Calcular tamaño final y reducción
    final_size = sum(
        os.path.getsize(os.path.join(dirpath, filename))
        for dirpath, _, filenames in os.walk(parent_folder)
        for filename in filenames
    )

    # Calcular estadísticas
    size_difference = initial_size - final_size
    size_difference_mb = size_difference / (1024 * 1024)
    reduction_percentage = (size_difference / initial_size) * 100 if initial_size > 0 else 0

    log(f"The folder has reduced its size by: {size_difference_mb:.2f} MB ({reduction_percentage:.2f}%)")
    log("")
    log("----------Conversion completed----------")
    log("")

if __name__ == "__main__":
    # Si se ejecuta directamente, usar el directorio actual
    convert_images_to_webp(os.getcwd())
