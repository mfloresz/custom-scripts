#!/bin/bash
for i in *.mp4; do ffmpeg -i "$i" -c:v libx264 -b:v 3500k -maxrate 5500k -bufsize 1835k -c:a copy -threads 1 ${i%.*}-done.mp4; done
