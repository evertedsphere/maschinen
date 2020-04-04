#!/usr/bin/env bash

set -euo pipefail

wpg -a ./wallpaper.jpg
wpg -i ./wallpaper.jpg ./colorscheme.json
wpg -s ./wallpaper.jpg

