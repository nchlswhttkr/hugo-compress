#!/bin/sh

hugo
find public -name "*.png" -exec /usr/bin/pngquant -f --ext .png {} \;

# Forgive this cursed line, it was how I got JPGs compressing - encountered
# problems with simultaneously reading and writing a file using mozjpeg
find public -name "*.jpg" -exec sh -c "/opt/mozjpeg/bin/cjpeg -quality 75 {} > /tmp/image.jpg && mv /tmp/image.jpg {}" \;
