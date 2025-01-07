import os
import sys
import zipfile
import shutil
import pyvips

def process_chapters(work_dir, start, end, position, color, digits, log_callback=None):
    os.chdir(work_dir)

    # Definir la posición del texto
    if position == 1:
        pos_offset = -860  # Posición superior
    elif position == 2:
        pos_offset = 0   # Posición media
    elif position == 3:
        pos_offset = 760   # Posición inferior
    else:
        pos_offset = 0   # Posición por defecto (media)

    # Definir el color del texto
    if color == 1:
        text_color = [245, 245, 245]  # Blanco
    elif color == 2:
        text_color = [50, 50, 50]  # Gris
    else:
        text_color = [245, 245, 245]  # Blanco por defecto

    # Ruta de la imagen base
    base_image_path = os.path.join(work_dir, "chapter.webp")
    if not os.path.exists(base_image_path):
        if log_callback:
            log_callback("Base image 'chapter.webp' not found.")
        return

    # Ruta de la fuente
    font_path = os.path.expanduser("~/.local/bin/OldLondon.ttf")
    if not os.path.exists(font_path):
        if log_callback:
            log_callback("Font file not found.")
        return

    # Procesar cada capítulo
    for a in range(int(start), int(end) + 1):
        b = str(a).zfill(digits)  # Rellenar con ceros a la izquierda
        dir_name = f"Chapter {b}"

        if os.path.isdir(dir_name):
            if log_callback:
                log_callback(f"Working on {dir_name}")

            # Cargar la imagen base
            base_image = pyvips.Image.new_from_file(base_image_path)

            # Crear una imagen de texto con fondo transparente
            text = str(a)
            text_image = pyvips.Image.text(
                text,
                fontfile=font_path,  # Ruta de la fuente
                font="Old London 38",
                dpi=300,  # Ajustar tamaño del texto
                align="centre",  # Alinear texto al centro (en inglés británico)
                rgba=True  # Habilitar transparencia
            )

            # Aplicar el color al texto
            # Extraer el canal alfa (transparencia)
            alpha = text_image.extract_band(3)
            # Crear una imagen de color sólido
            color_image = pyvips.Image.black(text_image.width, text_image.height).linear(
                [1, 1, 1],  # Multiplicador para cada canal (R, G, B)
                [c / 255 for c in text_color]  # Color del texto normalizado
            )
            # Combinar el color con el canal alfa
            text_image = color_image.bandjoin(alpha)

            # Convertir la imagen de texto a srgb
            text_image = text_image.colourspace("srgb")

            # Calcular la posición del texto
            text_width = text_image.width
            text_height = text_image.height
            position_x = (1500 - text_width) / 2  # Centrar horizontalmente
            position_y = (2121 / 2) + pos_offset - (text_height / 2)  # Ajustar verticalmente

            # Superponer el texto sobre la imagen base
            base_image = base_image.composite(
                [text_image],  # Imagen de texto
                "over",  # Modo de combinación
                x=[int(position_x)],  # Coordenada X
                y=[int(position_y)]  # Coordenada Y
            )

            # Guardar la imagen anotada
            output_path = os.path.join(dir_name, "000.webp")
            base_image.write_to_file(output_path)

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

            # Cargar la imagen base
            base_image = pyvips.Image.new_from_file(base_image_path)

            # Crear una imagen de texto con fondo transparente
            text = f"{a}.5"
            text_image = pyvips.Image.text(
                text,
                fontfile=font_path,  # Ruta de la fuente
                font="Old London 38",
                dpi=300,  # Ajustar tamaño del texto
                align="centre",  # Alinear texto al centro (en inglés británico)
                rgba=True  # Habilitar transparencia
            )

            # Aplicar el color al texto
            # Extraer el canal alfa (transparencia)
            alpha = text_image.extract_band(3)
            # Crear una imagen de color sólido
            color_image = pyvips.Image.black(text_image.width, text_image.height).linear(
                [1, 1, 1],  # Multiplicador para cada canal (R, G, B)
                [c / 255 for c in text_color]  # Color del texto normalizado
            )
            # Combinar el color con el canal alfa
            text_image = color_image.bandjoin(alpha)

            # Convertir la imagen de texto a srgb
            text_image = text_image.colourspace("srgb")

            # Calcular la posición del texto
            text_width = text_image.width
            text_height = text_image.height
            position_x = (1500 - text_width) / 2  # Centrar horizontalmente
            position_y = (2121 / 2) + pos_offset - (text_height / 2)  # Ajustar verticalmente

            # Superponer el texto sobre la imagen base
            base_image = base_image.composite(
                [text_image],  # Imagen de texto
                "over",  # Modo de combinación
                x=[int(position_x)],  # Coordenada X
                y=[int(position_y)]  # Coordenada Y
            )

            # Guardar la imagen anotada
            output_path = os.path.join(half_dir_name, "000.webp")
            base_image.write_to_file(output_path)

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
