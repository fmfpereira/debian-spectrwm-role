#!/bin/bash
#    ___      ___                 _         
#   / _/_ _  / _/__  ___ _______ (_)______ _
#  / _/  ' \/ _/ _ \/ -_) __/ -_) / __/ _ `/
# /_//_/_/_/_// .__/\__/_/  \__/_/_/  \_,_/ 
#            /_/         
# debian spectrwm status bar script.

# --- CONFIG VARIABLES DEFINITION

SLEEP_SEC=3

# --- SCRIPT START

# HDD
hdd() {
  hdd_percentage=$(df -h | awk 'NR==4{printf "%d", $5}')
  hdd=$(df -h | awk 'NR==4{printf "%s/%s", $3, $2}')
  # COMPUTE THE COLORS
  if (( $hdd_percentage > 90 )); then
    color="+@fg=1;"
  elif (( $hdd_percentage > 75 )); then
    color="+@fg=3;"
  else
    color="+@fg=0;"
  fi 
  echo -e "$color $hdd_percentage% [$hdd] "
}

# MEMORY
mem() {
  mem_percentage=$(free | awk '/Mem/ {printf "%d", $3/$2*100.0}')
  mem=$(free -h | awk '/Mem/ {printf "%s/%s", $3, $2}')
  # COMPUTE THE COLORS
  if (( $mem_percentage > 90 )); then
    color="+@fg=1;"
  elif (( $mem_percentage > 75 )); then
    color="+@fg=3;"
  else
    color="+@fg=0;"
  fi
  echo -e "$color $mem_percentage% [$mem] "
}

# CPU
cpu() {
  read cpu a b c previdle rest < /proc/stat
  prevtotal=$((a+b+c+previdle))
  sleep 0.5
  read cpu a b c idle rest < /proc/stat
  total=$((a+b+c+idle))
  cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
  # COMPUTE THE COLORS
  if (( $cpu > 90 )); then
    color="+@fg=1;"
  elif (( $cpu > 75 )); then
    color="+@fg=3;"
  else
    color="+@fg=0;"
  fi
  echo -e "$color $cpu% "
}

# BATERY
bat() {
  if [[ -d  /sys/class/power_supply/BAT0 ]]; then
    read present < /sys/class/power_supply/BAT0/present
    if [[ $present == 1 ]]; then
      read capacity < /sys/class/power_supply/BAT0/capacity
      read status < /sys/class/power_supply/BAT0/status
      # COMPUTE THE COLORS
      if (( $capacity <= 20 )); then
        color="+@fg=1;"
        icon=""
      elif (( $capacity <= 75 )); then
        color="+@fg=3;"
        icon=""
      elif (( $capacity <= 99 )); then
        color="+@fg=0;"
        icon=""
      else
        color="+@fg=0;"
        icon=""
      fi
      echo -e "$color$icon  $capacity% [$status] "
    fi
  fi
}

# WIRELESS
wifi() {
  ssid=$(/usr/sbin/iwgetid --raw)
  if [ -n "$ssid" ]; then
    strength="$(cat /proc/net/wireless | awk 'NR==3 {printf "%d", $3}')"
    # COMPUTE THE COLORS
    if (( $strength <= 20 )); then
      color="+@fg=1;"
    elif (( $strength <= 50 )); then
      color="+@fg=3;"
    else
      color="+@fg=0;"
    fi
    echo -e "$color $strength% [$ssid] "
  fi
}

# VOLUME
vol() {
  vol=$(amixer -D pulse get Master | awk -F'[][]' 'END{ printf "%d", $2 }')
  # COMPUTE THE COLORS
  if (( $vol == 0 )); then
    icon="ﱝ"
  elif (( $vol <= 25 )); then
    icon="奄"
  elif (( $vol <= 50 )); then
    icon=""
  elif (( $vol <= 75 )); then
    icon="墳"
  else
    icon=""
  fi
  echo -e "$icon $vol% "
}

# UPDATES
updates() {
  updates=$(apt-get dist-upgrade -s --quiet=2 | grep ^Inst | wc -l)
  icon="ﮮ"
  echo -e "$icon $updates "
}

while :; do
  echo "$(vol)+@fg=0;$(cpu)+@fg=0;$(mem)+@fg=0;$(hdd)+@fg=0;$(wifi)+@fg=0;$(updates)+@fg=0;$(bat)"
	sleep $SLEEP_SEC
done