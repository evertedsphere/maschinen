#!/usr/bin/env bash
#
# glitchy lockscreen script
#
# sources:
# https://github.com/x-zvf/dotfiles/blob/master/scripts/scrlock.sh
# https://maryknize.com/blog/glitch_art_with_sox_imagemagick_and_vim/

set -euo pipefail

scrot=@scrot@/bin/scrot
sox=@sox@/bin/sox
convert=@imagemagick@/bin/convert
i3lock=@i3lock@/bin/i3lock
rm=@coreutils@/bin/rm

pngFile="/tmp/lock-raw.png"
bmpFile="/tmp/lock-raw.bmp"
glitched="/tmp/lock-glitched.bmp"

$scrot -z $pngFile

# convert to bmp and pixelate
$convert -scale 50% -scale 200% $pngFile $bmpFile

# glitch it with sox 
# pitch [0.1-0.9] "shears" the image
$sox -t ul -c 1 -r 48k $bmpFile -t ul $glitched trim 0 60s : \
  pitch 0.5 \
  echo 0.8 0.88 20 0.1
$convert -rotate 90 $glitched $bmpFile
# "conjugating" with the pitch filter adds a ton of colour to the image
$sox -t ul -c 1 -r 48k $bmpFile -t ul $glitched trim 0 60s : \
  pitch 0.9 \
  echo 0.8 0.88 20 0.9 \
  pitch -0.9
$convert -rotate -90 $glitched $bmpFile

$convert $bmpFile $glitched

# Add lock icon and convert back to png
$convert -gravity center -font "FontAwesome-Regular" \
    -pointsize 200 -draw "text 0,0 ''" -channel RGBA -fill '#bf616a' \
    $glitched $pngFile

# -u disables circle indicator when entering characters
# -e doesn't try to authenticate when no character is entered
$i3lock -n -e -u -i $pngFile
$rm $pngFile $bmpFile $glitched
