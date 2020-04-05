#! /usr/bin/env nix-shell
#! nix-shell -i bash -p redshift

if [ "$(pgrep -x redshift)" ]; then
    temp=$(redshift -p 2> /dev/null | grep temp | cut -d ":" -f 2 | tr -dc "[:digit:]")
    echo $temp

    if [ -z "$temp" ]; then
        echo "%{F#65737E} #"
    elif [ "$temp" -ge 5000 ]; then
        echo "%{F#8FA1B3} #"
    elif [ "$temp" -ge 4000 ]; then
        echo "%{F#EBCB8B} #"
    else
        echo "%{F#D08770} #"
    fi
fi
