{ pkgs }:

''
  [settings]
  format-background = ''${env:polybar_background}
  format-foreground = ''${xrdb:color7:#222}
  format-underline =
  format-overline =
  format-spacing =
  format-padding = 0
  format-margin =
  format-offset = 0
  ; throttle-output = 5
  ; throttle-output-for = 10
  ; throttle-input-for = 30
  screenchange-reload = true
  compositing-background = over
  compositing-foreground = over
  compositing-overline = over
  compositing-underline = over
  compositing-border = over

  [global/wm]
  ; Adjust the _NET_WM_STRUT_PARTIAL top value
  ; Used for top aligned bars
  margin-bottom = 10

  ; Adjust the _NET_WM_STRUT_PARTIAL bottom value
  ; Used for bottom aligned bars
  margin-top = 10

  [colors]
  background = ''${env:polybar_background}
  foreground = ''${xrdb:color7:#222}
  foreground-alt = ''${xrdb:color7:#222}
  primary = ''${xrdb:color1:#222}
  secondary = ''${xrdb:color2:#222}
  alert = ''${xrdb:color3:#222}

  [section/base]
  fixed-center = true
  width = 1888
  height = 30
  offset-x = 16
  offset-y = 16
  border-size = 2
  border-color = ''${env:polybar_border}
  background = ''${colors.background}
  foreground = ''${colors.foreground}
  font-0 = PragmataPro Mono:size=13:style=Bold;4
  font-1 = PragmataPro Mono:size=13:style=Bold Italic;4
  font-2 = PragmataPro Mono:size=13:style=Regular;4
  font-3 = PragmataPro Mono:size=13:style=Italic;4
  padding = 1
  module-margin = 1

  ; --------------------------------------------------------------------

  [bar/top]
  inherit = section/base
  bottom = false

  modules-left = cpu ram wlan
  modules-center = xworkspaces
  modules-right = hackspeed date

  [bar/bottom]
  inherit = section/base
  bottom = true

  modules-left = backlight pulseaudio 
  modules-center = mpd
  modules-right = temperature battery

  ; --------------------------------------------------------------------

  [module/date]
  type = internal/date
  interval = 1.0
  date = %a %d %b %Y
  time = %H:%M:%S
  label = %date% %time%

  [module/backlight]
  type = internal/backlight
  card = intel_backlight
  format = light <label>

  [module/xwindow]
  type = internal/xwindow

  [module/cpu]
  type = internal/cpu
  format = cpu <label>
  label = %percentage:3%%

  [module/ram]
  type = internal/memory
  format = mem <label>
  label = %percentage_used:3%%

  [module/battery]
  type = internal/battery
  label-charging = adp %percentage%%
  label-discharging = bat %percentage%%
  label-full = fully charged

  [module/xworkspaces]
  type = internal/xworkspaces
  ; doesn't work with xmonad?
  pin-workspaces = false
  enable-click = false
  enable-scroll = false

  [module/mpd]
  type = internal/mpd
  format-online = <label-time> <toggle> <label-song>
  label-song = %title% - %album% (%artist%, %date:4:4%)
  icon-play = ⏵
  icon-pause = ⏸
  icon-stop = ⏹
  icon-prev = ⏮
  icon-next = ⏭

  [module/temperature]
  type = internal/temperature
  interval = 0.5
  ; To list all the zone types, run 
  ; $ for i in /sys/class/thermal/thermal_zone*; do echo "$i: $(<$i/type)"; done
  thermal-zone = 0
  base-temperature = 20
  warn-temperature = 80

  [module/pulseaudio]
  type = internal/pulseaudio
  sink = alsa_output.pci-0000_00_1f.3.analog-stereo
  use-ui-max = true
  interval = 5

  [module/wlan]
  type = internal/network
  interface = wlp8s0
  label-connected = rx %downspeed:9% tx %upspeed:9%

  [module/hackspeed]
  type = custom/script
  exec = ${pkgs.maschinen-scripts}/polybar-hackspeed.sh
  tail = true
''
