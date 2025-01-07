import re
import os
import argparse
from pathlib import Path

parser = argparse.ArgumentParser()
input_arguments = parser.add_mutually_exclusive_group(required=True)
input_arguments.add_argument("-s","--subtitle_file", help="name of the subtitles file to extract text from")
input_arguments.add_argument("-f","--subtitle_folder", help="name of the folder containing subtitles files to extract text from")
output_arguments = parser.add_mutually_exclusive_group()
output_arguments.add_argument("-o","--output-file", help="the name of the resulting text file")
output_arguments.add_argument("-d","--output-folder", help="the name of the folder for the resulting text files")
parser.add_argument("-t", "--timing-save",
                    help="save subtitle timing info into the following file path: name of input_file + \"_srt_info.txt\"", action="store_true")
print_options = parser.add_mutually_exclusive_group()
print_options.add_argument("-i", "--interval-in-one-line", help="subtitle text will be printed in one seperate line for each and every interval", action="store_true")
print_options.add_argument("-a", "--all-in-one-line", help="subtitle text will be printed in one line (block) for all intervals", action="store_true")
print_options.add_argument("-p", "--preserve-lines", help="(default) lines will be in the text files with the same formatting as the subtitle file", action="store_true")
arguments_parsed = parser.parse_args()

if arguments_parsed.subtitle_folder:
    folder = arguments_parsed.subtitle_folder
    subtitle_files = os.listdir(arguments_parsed.subtitle_folder)
elif arguments_parsed.subtitle_file:
    folder = "."
    subtitle_files = [arguments_parsed.subtitle_file]

if arguments_parsed.output_folder:
    output_folder = arguments_parsed.output_folder
elif arguments_parsed.subtitle_file:
    output_folder = "."

assert(not (arguments_parsed.subtitle_file and arguments_parsed.output_folder) and not (arguments_parsed.subtitle_folder and arguments_parsed.output_file)), "Input and output types are incompatible"

for file in subtitle_files:
    assert(Path(file).suffix == ".srt"),"Input file provided is not a .srt file or may be a directory"
    subtitle_file_name = file
    if arguments_parsed.timing_save:
        srt_info_file = subtitle_file_name.replace('.srt', "_srt_info.txt", 1)
    text_file_name = arguments_parsed.output_file if arguments_parsed.output_file else file.replace(".srt", ".txt", 1)

    with open(folder + "/" + subtitle_file_name, 'r', encoding='utf-8') as srt_file, open(output_folder + "/" + text_file_name, 'w', encoding='utf-8') as text_file:
        if arguments_parsed.timing_save:
            srt_info = open(output_folder + "/" + srt_info_file, "w", encoding='utf-8')

        subtitle_text = []
        in_subtitle_block = False

        for line in srt_file:
            line = line.strip()

            # Si es un número de secuencia
            if re.match(r'^\d+$', line):
                # Si tenemos texto acumulado del subtítulo anterior, lo escribimos
                if subtitle_text:
                    if arguments_parsed.all_in_one_line:
                        text_file.write(" ".join(subtitle_text) + " ")
                    else:
                        text_file.write("\n".join(subtitle_text) + "\n")
                    subtitle_text = []

                if arguments_parsed.timing_save:
                    srt_info.write(line + "\n")
                in_subtitle_block = True

            # Si es un intervalo de tiempo
            elif in_subtitle_block and re.match(r'^\d{2,}:[0-5][0-9]:[0-5][0-9],\d{3} --> \d{2,}:[0-5][0-9]:[0-5][0-9],\d{3}$', line):
                if arguments_parsed.timing_save:
                    srt_info.write(line + "\n")

            # Si es una línea en blanco, marca el fin del bloque de subtítulo
            elif line == "":
                in_subtitle_block = False

            # Si es texto del subtítulo (ignorando líneas que parezcan timestamps)
            elif in_subtitle_block and line and not re.match(r'^\d{2,}:[0-5][0-9]:[0-5][0-9],\d{3}', line):
                subtitle_text.append(line)

        # Escribir el último bloque de texto si existe
        if subtitle_text:
            if arguments_parsed.all_in_one_line:
                text_file.write(" ".join(subtitle_text))
            else:
                text_file.write("\n".join(subtitle_text) + "\n")

        if arguments_parsed.timing_save:
            srt_info.close()
