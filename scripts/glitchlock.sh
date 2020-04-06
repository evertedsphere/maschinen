#!/usr/bin/env bash
# glitchy lockscreen script, source:
# https://github.com/x-zvf/dotfiles/blob/master/scripts/scrlock.sh

set -euo pipefail

scrot=@scrot@/bin/scrot
sox=@sox@/bin/sox
convert=@imagemagick@/bin/convert
i3lock=@i3lock@/bin/i3lock

pngFile="/tmp/lock-raw.png"
bmpFile="/tmp/lock-raw.bmp"
glitched="/tmp/lock-glitched.bmp"

$scrot -z $pngFile

# convert to bmp and pixelate
$convert -scale 50% -scale 200% $pngFile $bmpFile

# glitch it with sox 
# https://maryknize.com/blog/glitch_art_with_sox_imagemagick_and_vim/
$sox -t ul -c 1 -r 48k $bmpFile -t ul $glitched trim 0 100s : echo 0.4 0.8 10 0.9
$convert -rotate 90 $glitched $bmpFile
$sox -t ul -c 1 -r 48k $bmpFile -t ul $glitched trim 0 100s : echo 0.9 0.9 15 0.9
$convert -rotate -90 $glitched $glitched

# Add lock icon, pixelate and convert back to png
$convert -gravity center -font "FontAwesome-Regular" \
    -pointsize 200 -draw "text 0,0 ''" -channel RGBA -fill '#bf616a' \
    $glitched $pngFile

# -u disables circle indicator when entering characters
# -e doesn't try to authenticate when no character is entered
$i3lock -n -e -u -i $pngFile
rm $pngFile $bmpFile $glitched
