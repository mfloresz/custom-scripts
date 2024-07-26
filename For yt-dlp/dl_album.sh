#!/bin/bash

url=$(kdialog --title "Descargar álbum de Youtube Music" --inputbox "Ingrese la url del álbum que desea descargar  ")

yt-dlp --cookies /home/misael/.local/CustomCommands/.cookies/YTDLnis_Cookies.txt --ignore-errors --format bestaudio --audio-quality 0 --add-metadata --parse-metadata "playlist_index:%(track_number)s"  --output "/home/misael/Descargas/%(uploader)s/%(album)s/%(playlist_index)s. %(title)s.%(ext)s" --yes-playlist $url

json_output=$(yt-dlp --dump-json --playlist-items 1 "$url")
uploader=$(echo "$json_output" | jq -r '.uploader')
album=$(echo "$json_output" | jq -r '.album')

yt-dlp --skip-download --write-thumbnail --match-title "Album -" --output "/home/misael/Descargas/$uploader/$album/cover.jpg" --yes-playlist "$url"

kdialog --title "Operación terminada" --passivepopup \
    "Se ha descargado el albúm correctamente" 10