import os
import zipfile
from PIL import Image, ImageDraw, ImageFont
import shutil
import platform

def get_font_path():
    """Retorna la ruta de la fuente según el sistema operativo"""
    system = platform.system()
    if system == "Windows":
        # Ruta para Windows
        return os.path.join(os.getenv('LOCALAPPDATA'), "bin", "OldLondon.ttf")
    else:
        # Ruta para Linux/Unix
        return os.path.expanduser("~/.local/bin/OldLondon.ttf")

def ask_confirmation():
    """Muestra mensaje de advertencia y solicita confirmación"""
    # Colores ANSI que funcionan en ambos sistemas
    try:
        import colorama
        colorama.init()
        YELLOW = '\033[1;33m'
        NC = '\033[0m'
    except ImportError:
        YELLOW = ''
        NC = ''

    print(f"{YELLOW}Warning: The following action will perform several operations.")
    print("Ensure that the image 'chapter.webp' exists.")
    print("Check the color and position of the text.")
    print("Take into account how many digits the series is (#,##,###,####).")
    print(f"Please take into account chapters #.5 (only), if there are any intermediates, make sure they comply with this format, otherwise they will be ignored.{NC}")

    response = input("¿Do you want to continue? (y/n): ")
    return response.lower() in ['y', 'yes']

def get_text_options():
    """Obtiene las opciones de texto del usuario"""
    print("Choose text position: (1) Upper (2) Middle (3) Lower")
    position = input("Enter choice: ")
    print("Choose text color: (1) White (2) Gray")
    color = input("Enter choice: ")
    print("Choose number of digits (1-4):")
    digits = int(input("Enter choice: "))
    return position, color, digits

def create_image_with_text(chapter_num, text_color, pos_offset, source_path, dest_path):
    """Crea una imagen con texto superpuesto"""
    try:
        # Abrir la imagen base
        img = Image.open(source_path)
        draw = ImageDraw.Draw(img)

        # Cargar la fuente
        try:
            font = ImageFont.truetype(get_font_path(), 150)
        except OSError:
            print(f"Error: Font file not found at {get_font_path()}")
            print("Please ensure OldLondon.ttf is in the correct location")
            return False

        # Obtener dimensiones de la imagen
        width, height = img.size

        # Calcular posición del texto
        # Usar getbbox() en lugar de textsize para mejor compatibilidad
        bbox = draw.textbbox((0, 0), str(chapter_num), font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        x = (width - text_width) // 2
        y = (height - text_height) // 2 + int(pos_offset)

        # Dibujar texto
        draw.text((x, y), str(chapter_num), font=font, fill=text_color)

        # Crear el directorio destino si no existe
        os.makedirs(os.path.dirname(dest_path), exist_ok=True)

        # Guardar imagen
        img.save(dest_path, 'WEBP')
        return True
    except Exception as e:
        print(f"Error creating image: {str(e)}")
        return False

def create_cbz(directory):
    """Crea archivo CBZ del directorio"""
    try:
        cbz_name = f"{directory}.cbz"
        with zipfile.ZipFile(cbz_name, 'w', zipfile.ZIP_DEFLATED) as zipf:
            for root, dirs, files in os.walk(directory):
                for file in files:
                    file_path = os.path.join(root, file)
                    arcname = os.path.relpath(file_path, directory)
                    zipf.write(file_path, arcname)
        return os.path.exists(cbz_name)
    except Exception as e:
        print(f"Error creating CBZ: {str(e)}")
        return False

def main():
    # Inicializar colorama para colores en Windows
    try:
        import colorama
        colorama.init()
    except ImportError:
        pass

    if not ask_confirmation():
        return

    try:
        start = int(input("Enter starting number: "))
        end = int(input("Enter ending number: "))
    except ValueError:
        print("Error: Please enter valid numbers")
        return

    position, color, digits = get_text_options()

    # Configurar posición y color
    pos_offset = {
        '1': "-880",
        '2': "-30",
        '3': "+740"
    }.get(position, "-30")

    text_color = {
        '1': "rgb(245, 245, 245)",
        '2': "rgb(128, 128, 128)"
    }.get(color, "rgb(245, 245, 245)")

    current_num = start

    for i in range(start, end + 1):
        chapter_num = str(i).zfill(digits)
        directory = f"Chapter {chapter_num}"

        if os.path.exists(directory):
            print(f"Working on Chapter {current_num}")

            # Crear imagen con texto
            if create_image_with_text(
                current_num,
                text_color,
                pos_offset,
                "chapter.webp",
                os.path.join(directory, "000.webp")
            ):
                # Crear CBZ y eliminar directorio original
                if create_cbz(directory):
                    shutil.rmtree(directory)
                else:
                    print(f"Failed to create CBZ for {directory}. Directory not deleted.")

        # Procesar capítulos .5
        half_dir = f"Chapter {chapter_num}.5"
        if os.path.exists(half_dir):
            print(f"Working on {half_dir}")

            if create_image_with_text(
                f"{current_num}.5",
                text_color,
                pos_offset,
                "chapter.webp",
                os.path.join(half_dir, "000.webp")
            ):
                if create_cbz(half_dir):
                    shutil.rmtree(half_dir)
                else:
                    print(f"Failed to create CBZ for {half_dir}. Directory not deleted.")

        current_num += 1

if __name__ == "__main__":
    main()
