#! /bin/bash
#
# This file is part of adapta-gtk-theme
#
# Copyright (C) 2016-2018 Tista <tista.gma500@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#

INKSCAPE="`command -v inkscape`"
SRC_DIR="../assets-xfwm"
ASSETS_DIR="../../xfwm4"
INDEX_SRC="assets-xfwm.txt"
INDEX=""
KEY_FILE="../../../sass/common/_key_colors.scss"

inkver="`$INKSCAPE --version | awk '{print $2}' | cut -c 1-4`"
if [ "$inkver" = 0.91 ]; then
    non_scale_dpi=90
else
    non_scale_dpi=96
fi

# Renderer
render-non-scale() {
    $INKSCAPE --export-dpi="$non_scale_dpi" --export-type=png  \
              --export-filename=$ASSETS_DIR/$i.png $SRC_DIR/$i.svg >/dev/null \
                                                              2>>../inkscape.log
}

# Generate PNG files
case "$1" in
    button1)
        INDEX=($(grep -e close -e hide -e maximize $INDEX_SRC))
        ;;
    button2)
        INDEX=($(grep -e menu -e 'shade-' -e stick $INDEX_SRC))
        ;;
    edge)
        INDEX=($(grep -e top -e left -e right -e bottom $INDEX_SRC))
        ;;
    title)
        INDEX=($(grep -e title $INDEX_SRC))
        ;;
    all)
        INDEX=$(<$INDEX_SRC)
        ;;
    *)
        exit 1
        ;;
esac

for i in ${INDEX[@]}
do
    if [ -f $ASSETS_DIR/$i.png ] && \
        [ $KEY_FILE -ot $ASSETS_DIR/$i.png ]; then
        echo $ASSETS_DIR/$i.png exists.
    elif [ -f $ASSETS_DIR/$i.png ] && \
        [ $KEY_FILE -nt $ASSETS_DIR/$i.png ]; then
        echo Re-rendering $ASSETS_DIR/$i.png
        echo $i.png >>../inkscape.log
        rm -f $ASSETS_DIR/$i.png
        render-non-scale
    else
        echo Rendering $ASSETS_DIR/$i.png
        echo $i.png >>../inkscape.log
        render-non-scale
    fi
done
