#!/bin/sh

# TODO: Support other OSes and ARCHes
# TODO: Support systems with curl but not wget
# TODO: Support systems with bsdtar but not tar

PANDOC_VERSION=3.9.0.2

mkdir -p bin/

if [ ! -f bin/pandoc ]; then
  wget https://github.com/jgm/pandoc/releases/download/$PANDOC_VERSION/pandoc-$PANDOC_VERSION-linux-amd64.tar.gz -O bin/pandoc.tar.gz
  tar -xf bin/pandoc.tar.gz -C bin/ --strip-components=2 pandoc-$PANDOC_VERSION/bin/pandoc
  rm bin/pandoc.tar.gz
fi

if [ ! -f bin/magick ]; then
  wget https://github.com/ImageMagick/ImageMagick/releases/download/7.1.2-18/ImageMagick-d4e4b2b-gcc-x86_64.AppImage -O bin/magick
  chmod u+x bin/magick
fi
