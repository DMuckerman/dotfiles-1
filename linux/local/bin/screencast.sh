#!/bin/bash
TMPFILE="$(mktemp -t screencast-XXXXXXX).mkv"
OUTPUT="$HOME/Dropbox/Screenshots/$(date +%Y-%m-%d_%H:%M:%S)"

read -r X Y W H G ID < <(slop -f "%x %y %w %h %g %i")
ffmpeg -f x11grab -s "$W"x"$H" -i :0.0+$X,$Y "$TMPFILE"

notify-send 'generating palette'
ffmpeg -y -i "$TMPFILE"  -vf fps=10,palettegen /tmp/palette.png
notify-send 'generating gif'
ffmpeg -i "$TMPFILE" -i /tmp/palette.png -filter_complex "fps=12,scale=720:-1,paletteuse" $OUTPUT.gif
mv $TMPFILE $OUTPUT.mkv

notify-send "size $(du -h $OUTPUT.gif | awk '{print $1}')"
rm $OUTPUT.mkv

eog $OUTPUT.gif

trap "rm -f '$TMPFILE'" 0
