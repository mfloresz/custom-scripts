import os
import sys
import zipfile
import shutil  # Para eliminar directorios de manera confiable
from PIL import Image, ImageFont, ImageDraw

def process_chapters(work_dir, start, end, position, color, digits, log_callback=None):
    os.chdir(work_dir)

    if position == 1:
        pos_offset = -880
    elif position == 2:
        pos_offset = -30
    elif position == 3:
        pos_offset = 740
    else:
        pos_offset = -30  # Default position

    if color == 1:
        text_color = (245, 245, 245, 255)  # White
    elif color == 2:
        text_color = (128, 128, 128, 255)  # Gray
    else:
        text_color = (245, 245, 245, 255)  # Default white

    base_image_path = "chapter.webp"
    if not os.path.exists(base_image_path):
        if log_callback:
            log_callback("Base image 'chapter.webp' not found.")
        return

    font_path = os.path.expanduser("~/.local/bin/OldLondon.ttf")
    if not os.path.exists(font_path):
        if log_callback:
            log_callback("Font file not found.")
        return
    font = ImageFont.truetype(font_path, 150)

    for a in range(int(start), int(end) + 1):
        b = str(a).zfill(digits)
        dir_name = f"Chapter {b}"

        if os.path.isdir(dir_name):
            if log_callback:
                log_callback(f"Working on {dir_name}")

            # Cargar una nueva copia de la imagen original en cada iteración
            base_image = Image.open(base_image_path)
            draw = ImageDraw.Draw(base_image)
            text = str(a)

            # Usar textbbox para calcular el tamaño del texto
            bbox = draw.textbbox((0, 0), text, font=font)
            text_width = bbox[2] - bbox[0]  # right - left
            text_height = bbox[3] - bbox[1]  # bottom - top

            # Calcular la posición basada en pos_offset
            position_x = (1500 - text_width) / 2  # Centrar horizontalmente
            position_y = (2121 / 2) + pos_offset - (text_height / 2)

            # Dibujar el texto principal (sin stroke)
            draw.text((position_x, position_y), text, font=font, fill=text_color)

            # Guardar la imagen anotada
            output_path = os.path.join(dir_name, "000.webp")
            base_image.save(output_path)

            # Crear archivo CBZ
            cbz_path = f"{dir_name}.cbz"
            with zipfile.ZipFile(cbz_path, 'w') as cbz:
                for root, _, files in os.walk(dir_name):
                    for file in files:
                        file_path = os.path.join(root, file)
                        cbz.write(file_path, os.path.relpath(file_path, dir_name))

            # Eliminar el directorio después de crear el CBZ
            shutil.rmtree(dir_name)
            if log_callback:
                log_callback(f"Created {cbz_path} and deleted folder {dir_name}")

        # Manejar capítulos con ".5"
        half_dir_name = f"Chapter {b}.5"
        if os.path.isdir(half_dir_name):
            if log_callback:
                log_callback(f"Working on {half_dir_name}")

            # Cargar una nueva copia de la imagen original en cada iteración
            base_image = Image.open(base_image_path)
            draw = ImageDraw.Draw(base_image)
            text = f"{a}.5"

            # Usar textbbox para calcular el tamaño del texto
            bbox = draw.textbbox((0, 0), text, font=font)
            text_width = bbox[2] - bbox[0]  # right - left
            text_height = bbox[3] - bbox[1]  # bottom - top

            # Calcular la posición basada en pos_offset
            position_x = (1500 - text_width) / 2  # Centrar horizontalmente
            position_y = (2121 / 2) + pos_offset - (text_height / 2)

            # Dibujar el texto principal (sin stroke)
            draw.text((position_x, position_y), text, font=font, fill=text_color)

            # Guardar la imagen anotada
            output_path = os.path.join(half_dir_name, "000.webp")
            base_image.save(output_path)

            # Crear archivo CBZ
            cbz_path = f"{half_dir_name}.cbz"
            with zipfile.ZipFile(cbz_path, 'w') as cbz:
                for root, _, files in os.walk(half_dir_name):
                    for file in files:
                        file_path = os.path.join(root, file)
                        cbz.write(file_path, os.path.relpath(file_path, half_dir_name))

            # Eliminar el directorio después de crear el CBZ
            shutil.rmtree(half_dir_name)
            if log_callback:
                log_callback(f"Created {cbz_path} and deleted {half_dir_name}")
